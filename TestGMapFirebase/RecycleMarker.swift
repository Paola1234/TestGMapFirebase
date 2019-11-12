//
//  RecycleMarker.swift
//  TestGMapFirebase
//
//  Created by Paola Latino on 11/7/19.
//  Copyright © 2019 LADY PAOLA LATINO TOVAR. All rights reserved.
//

import UIKit
import GoogleMaps

class RecycleMarker: GMSMarker {
  // 1
  let place: GooglePlace
  
  // 2
  init(place: GooglePlace) {
    self.place = place
    super.init()
    
    position = place.coordinate
    icon = UIImage(named: place.placeType+"_pin")
    groundAnchor = CGPoint(x: 0.5, y: 1)
    appearAnimation = .pop
  }
}

