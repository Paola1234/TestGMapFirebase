//
//  ViewController.swift
//  TestGMapFirebase
//
//  Created by LADY PAOLA LATINO TOVAR on 11/6/19.
//  Copyright © 2019 LADY PAOLA LATINO TOVAR. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController{

    @IBOutlet weak var myMapRoundedButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.myMapRoundedButton.layer.cornerRadius = 18
    }
   
}



