//
//  LoadPlaces.swift
//  GoogleMapsEvents
//
//  Created by Chanbasha Shaik on 26/08/18.
//  Copyright © 2018 dev. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class LoadPlaces: UIViewController {
    var sourceLocation = CLLocation()
    var destLatitude = CLLocationDegrees()
    var destLongitude = CLLocationDegrees()
    @IBOutlet var routeMap: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving")!
        //&mode=driving
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else{
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        let routes = json["routes"] as? [Any]
                        print(routes!)
//                        let overview_polyline = routes?[0] as?[String:Any]
//
//                        print(overview_polyline!)
//                        let polyString = overview_polyline?["points"] as?String
//
                        //Call this method to draw path on map
                        
                        
                        //self.showPath(polyStr: polyString!)
                        
//                        for route in routes!
//                        {
//                            let routeOverviewPolyline = route["overview_polyline"]
//                            let points = routeOverviewPolyline?["points"]?.stringValue
//                            let path = GMSPath.init(fromEncodedPath: points!)
//                            let polyline = GMSPolyline.init(path: path)
//                            polyline.strokeWidth = 4
//                            polyline.strokeColor = UIColor.red
//                            polyline.map = self.googleMaps
//                        }
                    }
                    
                }catch{
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
    func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = routeMap // Your map view
    }

}
