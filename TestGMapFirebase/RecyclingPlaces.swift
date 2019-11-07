//
//  RecyclingPlaces.swift
//  TestGMapFirebase
//
//  Created by Paola Latino on 11/7/19.
//  Copyright © 2019 LADY PAOLA LATINO TOVAR. All rights reserved.
//

import Foundation
import GoogleMaps
import UIKit

class RecyclingPlaces: GMSMarker {
  // 1
  let place: GooglePlaces
  
  // 2
  init(place: GooglePlaces) {
    self.place = place
    super.init()
    
    position = place.coordinate
    icon = UIImage(named: place.placeType+"_pin")
    groundAnchor = CGPoint(x: 0.5, y: 1)
    appearAnimation = .pop
  }
}

