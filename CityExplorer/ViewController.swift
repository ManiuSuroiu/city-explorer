//
//  ViewController.swift
//  CityExplorer
//
//  Created by Maniu Suroiu on 03/06/2017.
//  Copyright © 2017 Maniu Suroiu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testButton: UIButton!
    
    let date = Date()
    
    @IBAction func testAction(_ sender: Any) {
        getVenuesFromFoursquare()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /* Convenience method to build the URL */
    private func buildFoursquareURL(_ parameters: [String: AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Foursquare.APIScheme
        components.host = Constants.Foursquare.APIHost
        components.path = Constants.Foursquare.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    
    private func parseJSON(json data: Data) -> [String: AnyObject]? {
        return nil
    }
    
    private func getVenuesFromFoursquare() {
        
        
        
        let methodParameters = [
            Constants.FoursquareParameterKeys.ClientID: Constants.FoursquareParametersValues.ClientID,
            Constants.FoursquareParameterKeys.ClientSecret: Constants.FoursquareParametersValues.ClientSecret,
            Constants.FoursquareParameterKeys.LatLongCoordinates: Constants.FoursquareParametersValues.LatLongCoordinates,
            Constants.FoursquareParameterKeys.Query: Constants.FoursquareParametersValues.Query,
            Constants.FoursquareParameterKeys.LimitResults: Constants.FoursquareParametersValues.LimitResults,
            Constants.FoursquareParameterKeys.VenuePhoto: Constants.FoursquareParametersValues.VenuePhoto,
            Constants.FoursquareParameterKeys.APIVersion: self.dateToString(date),
            Constants.FoursquareParameterKeys.ModeResponse: Constants.FoursquareParametersValues.ModeResponse
        ]
        
        let session = URLSession.shared
        let request = URLRequest(url: buildFoursquareURL(methodParameters as [String : AnyObject]))
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            /* If an error occurs print it */
            func displayError(_ error: String) {
                print(error)
            }
            
            /* Was there any error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2XX")
                return
            }
            
            /* Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request")
                return
            }
            
            /* Parsing the data */
            let parsedResult: [String: AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* Get the 'response' dictionary */
            guard let responseDictionary = parsedResult[Constants.FoursquareResponseKeys.Response] as? [String: AnyObject] else {
                displayError("Could not find key '\(Constants.FoursquareResponseKeys.Response)' in \(parsedResult)")
                return
            }
            
            /* Get the 'groups' array of dictionaries */
            guard let groupsArray = responseDictionary[Constants.FoursquareResponseKeys.Groups] as? [[String: AnyObject]] else {
                displayError("Could not find key '\(Constants.FoursquareResponseKeys.Groups)' in \(responseDictionary)")
                return
            }
            
            /* Get the dictionary within the groups array. Access the first element of the array as it contains only one dictionary */
            let groupDictionary = groupsArray[0]
            
            /* Get the 'items' array within the groupDictionary */
            guard let itemsArray = groupDictionary[Constants.FoursquareResponseKeys.Items] as? [[String: AnyObject]] else {
                displayError("Could not find key '\(Constants.FoursquareResponseKeys.Items)' in \(groupDictionary)")
                return
            }
            
            /* The 'items' array contains dictionaries which include the venues and their details. Iterate through the array to retrieve the venues */
            for itemDictionary in itemsArray {
                
                /* Get the 'venue' dictionary */
                guard let venueDictionary = itemDictionary[Constants.FoursquareResponseKeys.Venue] as? [String: AnyObject] else {
                    displayError("Could not find key '\(Constants.FoursquareResponseKeys.Venue)' in \(itemDictionary)")
                    return
                }
                
                /* Get the venue names found within the bounds of the user's location */
                guard let venueName = venueDictionary[Constants.FoursquareResponseKeys.Name] as? String else {
                    displayError("Could not find key '\(Constants.FoursquareResponseKeys.Name)' in \(venueDictionary)")
                    return
                }
                
                /* Get the 'location' dictionary of the venues retrieved */
                guard let venueLocation = venueDictionary[Constants.FoursquareResponseKeys.Location] as? [String: AnyObject] else {
                    displayError("Could not find key '\(Constants.FoursquareResponseKeys.Location)' in \(venueDictionary)")
                    return
                }
                
                /* Get the 'formatted address' array within the venueLocation dictionary to retrieve the venue address */
                guard let formattedAddress = venueLocation[Constants.FoursquareResponseKeys.FormattedAddress] as? [String] else {
                    displayError("Could not find key '\(Constants.FoursquareResponseKeys.FormattedAddress)' in \(venueLocation)")
                    return
                }
                
                /* Get the 'distance' key to retrieve the distance between the user's location and the venue */
                guard let distance = venueLocation[Constants.FoursquareResponseKeys.Distance] as? Int else {
                    displayError("Could not find key '\(Constants.FoursquareResponseKeys.Distance)' in \(venueLocation)")
                    return
                }
                
                /* Get the 'categories' array from the venue dictionary to retrieve an icon photo assigned for that particular category */
                guard let categoriesArray = venueDictionary[Constants.FoursquareResponseKeys.Categories] as? [[String: AnyObject]] else {
                    displayError("Could not find key '\(Constants.FoursquareResponseKeys.Categories)' in \(venueDictionary)")
                    return
                }
                
                /* Get the dictionary within the 'categories' array to access the icon dictionary containing the photo url. Access the first element of the array as it contains only one dictionary */
                let categoryDictionary = categoriesArray[0]
                
                /* Access the 'icon' dictionary to retrieve the 'prefix' and 'suffix' values which together form the photo url */
                guard let categoryIcon = categoryDictionary[Constants.FoursquareResponseKeys.Icon] as? [String: AnyObject] else {
                    displayError("Could not find key '\(Constants.FoursquareResponseKeys.Icon)' in \(categoryDictionary)")
                    return
                }
                
                /* Get the prefix of the photo url */
                guard let iconPrefix = categoryIcon[Constants.FoursquareResponseKeys.Prefix] as? String else {
                    displayError("Could not find key '\(Constants.FoursquareResponseKeys.Prefix)' in \(categoryIcon)")
                    return
                }
                
                /* Get the suffix of the photo url */
                guard let iconSuffix = categoryIcon[Constants.FoursquareResponseKeys.Suffix] as? String else {
                    displayError("Could not find key '\(Constants.FoursquareResponseKeys.Suffix)' in \(categoryIcon)")
                    return
                }
                
                /* Get the rating for that particular venue */
                guard let venueRating = venueDictionary[Constants.FoursquareResponseKeys.Rating] as? Double else {
                    displayError("Could not find key '\(Constants.FoursquareResponseKeys.Rating)' in \(venueDictionary)")
                    return
                }
            }
        }
        task.resume()
    }
}

extension ViewController {
    
    func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let stringFromDate = formatter.string(from: date)
        let todaysDate = formatter.date(from: stringFromDate)
        
        formatter.dateFormat = "yyyyMMdd"
        let dateString = formatter.string(from: todaysDate!)
        
        return dateString
    }
}















