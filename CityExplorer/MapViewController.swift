//
//  MapViewController.swift
//  CityExplorer
//
//  Created by Maniu Suroiu on 12/06/2017.
//  Copyright © 2017 Maniu Suroiu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textField: UITextField!
    
    // MARK: - Instance variables
    var locationManager = CLLocationManager()
    var startLocation: CLLocation?
    var updatingLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        determineLocationAuthStatus()
    }
    
    /* determines the location authorization status and performs a certain action associated with that status (for instance if the status is "authorized when in use" it will call startLocationManager() method to start updating the user's location) */
    func determineLocationAuthStatus() {
        let authStatus = CLLocationManager.authorizationStatus()
        
        switch authStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            perform(#selector(presentLocationAccessDeniedViewController), with: nil, afterDelay: 2)
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationManager()
        }
    }
    
    /* modal presentation of a new view controller - no segue - providing the user with info that location access hasn't been authorized and a button that prompts the user to the Settings app to change the authorization status to "allow location access when in use" */
    func presentLocationAccessDeniedViewController() {
        let viewController: LocationAccessDeniedViewController
        viewController = storyboard?.instantiateViewController(withIdentifier: "LocationAccessDeniedViewController") as! LocationAccessDeniedViewController
        present(viewController, animated: true, completion: nil)
    }
    
    /* CLLocationManager into action - this is where it obtains GPS coordinates (by calling the startUpdatingLocation() method) */
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    /* once the location manager begins updating user's location, put the latitude and longitude in the format required by the Foursquare API parameter (LatLongCoordinates - Constants.swift). Call this method from the delegate method locationManager(didUpdateLocations:) */
    func formatGPSCoordinates() -> String {
        if let location = startLocation {
            let latitudeString = String(format: "%.8f", location.coordinate.latitude)
            let longitudeString = String(format: "%.8f", location.coordinate.longitude)
            return latitudeString + "," + longitudeString
        } else {
            return "Location coordinates could not be retrieved"
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

    // MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    /* Tells the delegate that the location manager was unable to retrieve a location value. Uses a switch statemnet to look at the most common reasons that caused the error to occur. Each case creates an alert view controller to show the respective error to the user  */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        switch (error as NSError).code {
            
        case CLError.network.rawValue:
            let alert = UIAlertController(title: "Network Error",
                                          message: "The network is unavailable or a network error occurred",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
        case CLError.locationUnknown.rawValue:
            let alert = UIAlertController(title: "Error Getting Location",
                                          message: "The GPS is unable to obtain your location right now",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        default:
            let alert = UIAlertController(title: "An Error Has Occurred",
                                          message: "Your location cannot be determined right now",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    /* Tells the delegate that new location data is available while storing it in a [ClLocation] array (second parameter) */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        startLocation = newLocation
        print(formatGPSCoordinates())
    }
}












