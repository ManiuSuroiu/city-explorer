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
    
    /* prompts the user to the Settings app to change the status of the Location Services */
    @IBAction func goToSettings(_ sender: Any) {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* notifies the view controller that the application is now in the foreground (by calling the AppDelegate applicationDidBecomeActive() method) and specifies the method responsible with dismissing the viewcontroller */
        NotificationCenter.default.addObserver(self, selector: #selector(dismissIfLocationAccessAuthorizedWhenInUse), name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        /* removes the observer created above, once the viewWillDisappear is being called (the view controller is about to be dismissed and therefore the observer added must be removed */
        NotificationCenter.default.removeObserver(self, name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    /* dismisses the view controller when the user has authorized location access */
    func dismissIfLocationAccessAuthorizedWhenInUse() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.dismiss(animated: true, completion: nil)
        }
    }
}





















