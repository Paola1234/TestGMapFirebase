//
//  MapViewController.swift
//  TestGMapFirebase
//
//  Created by LADY PAOLA LATINO TOVAR on 11/6/19.
//  Copyright © 2019 LADY PAOLA LATINO TOVAR. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {

    //Outlets
    @IBOutlet weak var mapRecycle: GMSMapView!
    @IBOutlet weak var labelLocation: UILabel!
    
    @IBOutlet weak var refresh: UIBarButtonItem!
    @IBOutlet weak var filter: UIBarButtonItem!
    
    //Constants/properties
    private var searchedTypes = ["Plástico", "Vidrio", "Cartón", "Papel", "Metal"]
    private let locationManager = CLLocationManager()
    private let dataProvider = GoogleDataProvider()
    private let searchRadius: Double = 1000

    
    //View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Ask for authorization for location and gets current location
        locationManager.delegate = self as! CLLocationManagerDelegate
        locationManager.requestWhenInUseAuthorization()
        
        //Makes this View Controller the map view's delegate
        mapRecycle.delegate = self
    }
    
    
    //Converts the location from Latitude and Longitud, to an address to show in the Location Label
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
      // Creates an Object GMSGeocoder which can convert the latitud and longitud to address
      let geocoder = GMSGeocoder()
        
      // Make here a conditional to ask for connection before asking for location and replace label
      // to "Check your internet connection, in order to get the specific address"
        
      //Asks the geocoder to get the address from the coordinates
      geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
        guard let address = response?.firstResult(), let lines = address.lines else {
          return
        }
        //Sets the label with the information
        self.labelLocation.text = lines.joined(separator: "\n")
        // 1Padding so it shows the Location button
        let labelHeight = self.labelLocation.intrinsicContentSize.height
        self.mapRecycle.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0,
                                            bottom: labelHeight, right: 0)
        
        // Animates the changes in the content and updates the location pin’s position to match the map’s padding by adjusting its vertical layout constraint.
        UIView.animate(withDuration: 0.25) {
          //self.pinImageVerticalConstraint.constant = ((labelHeight - self.view.safeAreaInsets.top) * 0.5)
          self.view.layoutIfNeeded()
        }
      }
    }
    
    private func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
      // Clear the map of all the markers
      mapRecycle.clear()
      // Use dataProvider to query Google for nearby places within the searchRadius, filtered to the user’s selected types
      dataProvider.fetchPlacesNearCoordinate(coordinate, radius:searchRadius, types: searchedTypes) { places in
        places.forEach {
          // Iterate through the results returned in the completion closure and create a PlaceMarker for each result and sets the marker in the map.
          let marker = RecycleMarker(place: $0)
          marker.map = self.mapRecycle
        }
      }
    }
   // Refresh places in the current map
    @IBAction func refreshPlaces(_ sender: Any) {
        fetchNearbyPlaces(coordinate: mapRecycle.camera.target)
    }
    
    
    
}

// MARK: - TypesTableViewControllerDelegate
extension MapViewController: TypesTableViewControllerDelegate {
  func typesController(_ controller: TypesTableViewController, didSelectTypes types: [String]) {
    searchedTypes = controller.selectedTypes.sorted()
    dismiss(animated: true)
    fetchNearbyPlaces(coordinate: mapRecycle.camera.target)
  }
}

// MARK: - CLLocationManagerDelegate
//1
extension MapViewController: CLLocationManagerDelegate {
  // called when the user grants or revokes location permissions.
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    // Help to check if the user has granted permission while the app is in use.
    guard status == .authorizedWhenInUse else {
      return
    }
    //Once the permission for the location is granted, asks the location manager for updates on the user’s location.
    locationManager.startUpdatingLocation()
      
    //Has two features concerning the user’s location:
    //1. myLocationEnabled draws a light blue dot where the user is located
    //2. myLocationButton, when set to true, adds a button to the map that, when tapped, centers the map on the user’s location.
    mapRecycle.isMyLocationEnabled = true
    mapRecycle.settings.myLocationButton = true
  }
  
  // Executes when the location manager receives new location data.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }
      
    // Updates the map’s camera to center around the user’s current location. The GMSCameraPosition class aggregates all camera position parameters and passes them to the map for display.
    mapRecycle.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
      
    // Tell locationManager you’re no longer interested in updates; you don’t want to follow a user around as their initial location is enough for you to work with
    locationManager.stopUpdatingLocation()
  
    // the user has the ability to change the types of places to display on the map, so needs to update the search results if the selected types change.
    fetchNearbyPlaces(coordinate: location.coordinate)
    
    }
    
   //Get Places from Firebase
    func getPlacesFirebase(){
        
    }
}

// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    
    func mapRecycle(_ mapRecycle: GMSMapView, idleAt position: GMSCameraPosition) {
      reverseGeocodeCoordinate(position.target)
    }
    func mapRecycle(_ mapRecycle: GMSMapView, willMove gesture: Bool) {
//        Check why error: self.labelLocation.lock()
    }
    
    
    func loadLocationsNearFromFirebase(){
        
    }
}
