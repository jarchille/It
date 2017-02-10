//
//  ApiHandler.swift
//  AppStore
//
//  Created by Jonathan Archille on 1/29/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import SwiftyJSON
import Toucan
import Firebase


protocol ProfileImageDelgate {
    func updateImage(image: UIImage)
}

class APIHandler {
    
    var delegate: ProfileImageDelgate?
    
    private var accessToken: String!
    private let clientId: String = "mQe1GX9WwDjTIISt0MR8Pg"
    private let clientSecret: String = "OiEImga4rpY501EVD5SVLZDtoSMmW4Zg61x6oxjSIeDPRUFD6C5uVcHE2E9qk5Is"
    
    private func getAccessToken(completionHandler: @escaping (NSError?) -> Void) {
        let url = NSURL(string: "https://api.yelp.com/oauth2/token")
        let request = NSMutableURLRequest(url: url as! URL)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        
        let postBody = "grant_type=client_credentials&client_id=" + clientId + "&client_secret=" + clientSecret
        let postData = NSMutableData(data: postBody.data(using: String.Encoding.utf8)!)
        
        request.httpBody = postData as Data
        
        //let apiError = NSError(domain: "Could not obtain access_token from Yelp server.", code: 300, userInfo: nil)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                print (error?.localizedDescription ?? "data error")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                
                if let returnedToken = json["access_token"] as? String {
                    self.accessToken = returnedToken
                }
            } catch let err  {
                print(err)
                return
            }
        }
        task.resume()
    }
    
    var searchCoords: CLLocationCoordinate2D?
    
    func searchYelp(coordinates: CLLocationCoordinate2D, completion: @escaping (Business?, NSError?) -> Void) {
        /*let locale = "en_US"
         let radius = 1000
         let sort_by = "distance"
         let limit = 3*/
        let parameterForNow = ""
        searchCoords = coordinates
        
        if accessToken == nil {
            getAccessToken(completionHandler: { (tokenError) in
                if (tokenError != nil) {
                    //                    print("error in access token retrieval")
                    completion(nil, tokenError)
                    return
                }
                self.searchYelp(coordinates: coordinates, completion: completion)
                
            })
        }else {
            
            
            let searchString = "?term=" + parameterForNow + "&latitude=" + String(coordinates.latitude) + "&longitude=" + String(coordinates.longitude) + "&locale=en_US&limit=1&sort_by=distance"
            let url = URL(string: "https://api.yelp.com/v3/businesses/search" + searchString)
            let request = NSMutableURLRequest(url: url!)
            request.httpMethod = "GET"
            request.addValue("Bearer " + self.accessToken, forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                if error != nil {
                    print("error in search data task")
                    return
                }
                    let json = JSON(data: data!)
                    let business = self.createBusinessObject(business: json)
                    completion(business, nil)
                
        
                
            }).resume()
        }
        

        
        
        
    }
    
    func createBusinessObject(business json: JSON) -> Business {
        
        let image_url = json["businesses"][0]["image_url"].stringValue

        let name = json["businesses"][0]["name"].stringValue
        let address = (json["businesses"][0]["location"]["display_address"].arrayValue.map({$0.stringValue})).joined(separator: ", ")
        let categories = json["businesses"][0]["categories"].arrayValue.map({$0["title"].stringValue}).joined(separator: ", ")
        
        
        let aBusiness = Business(name: name, address: address, category: categories, imageUrl: image_url, coordinates: searchCoords!)
        
        fetchImage(imageUrl: image_url, completion: { image in
            
            let img = Toucan(image: image).resize(CGSize(width: 100, height: 100), fitMode: Toucan.Resize.FitMode.crop).maskWithRoundedRect(cornerRadius: 10, borderWidth: 1, borderColor: .black).image
            self.delegate?.updateImage(image: img)
        })
        
       return aBusiness
    }
    
    func fetchImage(imageUrl: String, completion: @escaping (UIImage) -> Void) {
        
        Alamofire.request(imageUrl).responseData(completionHandler: { response in
            
            if let data = response.result.value {
                guard let img = UIImage(data: data) else { return }
                completion(img)
                
            } else {
                completion(#imageLiteral(resourceName: "no-image"))
            }
            
        })
        
        if FIRAuth.auth()?.currentUser?.uid != nil {
            setUsers()
        } else {
            print("user authenticaion failed")
        }
    }
    
    func setUsers() {
    
    
    }
        
    
}



class Business: NSObject {
    var name: String
    var address: String
    var categories: String
    var image_url: String
    var coordinates: CLLocationCoordinate2D

    
    
    var image: UIImage?
    
    init(name: String, address: String, category: String, imageUrl: String, coordinates: CLLocationCoordinate2D) {
        
        self.name = name
        self.address = address
        categories = category
        image_url = imageUrl
        self.coordinates = coordinates
        
    }
    
    
}
