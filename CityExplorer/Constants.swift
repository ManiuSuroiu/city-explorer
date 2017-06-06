//
//  Constants.swift
//  CityExplorer
//
//  Created by Maniu Suroiu on 03/06/2017.
//  Copyright © 2017 Maniu Suroiu. All rights reserved.
//
import UIKit
// MARK: - Constants

struct Constants {
    
    // MARK: - Foursquare
    struct Foursquare {
        static let APIScheme = "https"
        static let APIHost = "api.foursquare.com"
        static let APIPath = "/v2/venues/explore"
    }
    
    // MARK: - Foursquare parameter keys
    struct FoursquareParameterKeys {
        static let ClientID = "client_id"
        static let ClientSecret = "client_secret"
        static let LatLongCoordinates = "ll"
        static let Query = "query"
        static let LimitResults = "limit"
        static let VenuePhoto = "venuePhoto"
        static let APIVersion = "v"
        static let ModeResponse = "m"
    }
    
    // MARK: - Foursquare parameter values
    struct FoursquareParametersValues {
        static let ClientID = "KZWTYU4QVE2XGVX50FUW0OJ21BJ343VVB4OE0H5OVEBS4TSS"
        static let ClientSecret = "FQHAWFPUGKDJEK40ZL5KVC51MK5MONB3E0VMZKX04MKS1425"
        static let LatLongCoordinates = "51.51,0.14" /* Use the user coordinates later */
        static let Query = "sushi" /* Use the textfield.text attribute (let the user insert the query) */
        static let LimitResults = "50"
        static let VenuePhoto = "1"
        static let APIVersion = "20170602"
        static let ModeResponse = "foursquare"
    }
    
    //MARK: - Foursquare response keys
    struct FoursquareResponseKeys {
        static let Response = "response"
        static let Groups = "groups"
        static let Items = "items"
        static let Venue = "venue"
        static let Name = "name"
        static let Rating = "rating"
        static let Location = "location"
        static let Distance = "distance"
        static let FormattedAddress = "formattedAddress"
        static let Categories = "categories"
        static let Icon = "icon"
        static let Prefix = "prefix"
        static let Suffix = "suffix"
        static let Tips = "tips"
        static let PhotoURL = "photourl"
    }
}



















