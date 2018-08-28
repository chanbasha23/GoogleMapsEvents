//
//  ViewController.swift
//  GoogleMapsEvents
//
//  Created by Chanbasha Shaik on 26/08/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces



protocol currentLocation {
    func latAndLong(lat:CLLocationDegrees,long:CLLocationDegrees)
}

class ViewController: UIViewController,CLLocationManagerDelegate,GMSAutocompleteViewControllerDelegate {
    

    var locationManager = CLLocationManager()
    var location = CLLocation()
    
    var delegate : currentLocation!
    var destLatitude = CLLocationDegrees()
    var destLongitude = CLLocationDegrees()
    var destCordnates = CLLocationCoordinate2D()
    
    //var destPlace = GMSPlace()
    
    
    
    
    @IBOutlet var map: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self

        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        map.isMyLocationEnabled = true
        map.settings.myLocationButton = true
        // Check for Location Services
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       //Getting user Location
        self.location = locations.last!
//        delegate.latAndLong(lat:self.location.coordinate.latitude , long:self.location.coordinate.longitude)
//sourceLatitude = self.location.coordinate.latitude
//        sourceLongitude = self.location.coordinate.longitude
       // sourceLocation = locations.last!
        
        showCurrentLocation()
        self.locationManager.stopUpdatingLocation()
        
    }
 
    func showCurrentLocation()
    {
        let cordinates = self.location.coordinate
      //Reverse Geocoding
        let geoCoder = GMSGeocoder()
         let center = CLLocationCoordinate2D(latitude: cordinates.latitude, longitude: cordinates.longitude)
        
        
        geoCoder.reverseGeocodeCoordinate(cordinates) { response , error in
            if let address = response?.firstResult() {
                let line = address.lines
                let subarea = address.subLocality
                
                let door = line?.last
                print("This is my \(door!)")
                self.navigationController?.title = door
                let markerImageView: UIImageView? = nil
                
                markerImageView?.image = UIImage(named: "locationICon")
                //print(markerImageView?.image!!)
                markerImageView?.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
                
                markerImageView?.layer.borderWidth = 1.0
                markerImageView?.layer.masksToBounds = false
                markerImageView?.layer.borderColor = UIColor.white.cgColor
                //markerImageView?.layer.cornerRadius = (markerImageView?.frame.size.width)! / 2
                markerImageView?.clipsToBounds = true
                
                //let actualFinalImage = markerImageView?.image
                
                //marker.icon = actualFinalImage
                let marker = GMSMarker()
                marker.position = center
                marker.title = "subarea"
                marker.icon = UIImage(named: "locationICon")
                marker.map = self.map
                let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude:cordinates.latitude, longitude: cordinates.longitude, zoom:17)
                self.map.animate(to: camera)
                
            }
        }
        
    }
    
    @IBAction func locatePlaces(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VC") as!
        LoadPlaces
    
       vc.getPolylineRoute(from: self.location.coordinate, to: destCordnates)
        
        
        
      // self.navigationController?.popViewController(animated: true)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "vc") as! LoadPlaces
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    func direction() {
        //kalluru-lat(13.5572)-long(78.9995)
        //chittoor-lat(13.2172)-long(79.1003)
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?query=bank&key=AIzaSyClVfcfcua3HegfZn27A78sBxkFQLmcVuY")
        let task = URLSession.shared.dataTask(with: url!) { (data:Data?, response:URLResponse?, error:Error?) in
            if let data = data {
                do {
                    // Convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    
//                    if let json = jsonSerialized, let url = json["url"], let explanation = json["explanation"] {
//                        print(url)
//                        print("my life is my life\(json)")
//                    }
                    print(jsonSerialized!)
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let center = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
       destCordnates = place.coordinate
    
        let marker = GMSMarker()
        marker.position = center
      //  marker.title = "subarea"
        marker.icon = UIImage(named: "locationICon")
        marker.map = self.map
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude:place.coordinate.latitude, longitude: place.coordinate.longitude, zoom:17)
        self.map.animate(to: camera)
        self.dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("\(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func search(_ sender: Any) {
        
        let autocomplete = GMSAutocompleteViewController()
        autocomplete.delegate = self
        locationManager.startUpdatingLocation()
        self.present(autocomplete, animated: true, completion: nil)

        
        
    }
}
    
    
    



