//
//  LocationAccessDeniedViewController.swift
//  CityExplorer
//
//  Created by Maniu Suroiu on 14/06/2017.
//  Copyright © 2017 Maniu Suroiu. All rights reserved.
//

import UIKit
import CoreLocation


class LocationAccessDeniedViewController: UIViewController {
    
    @IBOutlet weak var goToSettingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissIfLocationAccessAuthorizedWhenInUse), name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    @IBAction func goToSettings(_ sender: Any) {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    func dismissIfLocationAccessAuthorizedWhenInUse() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.dismiss(animated: true, completion: nil)
        }
    }
}





















