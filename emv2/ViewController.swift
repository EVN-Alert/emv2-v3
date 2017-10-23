//
//  ViewController.swift
//  emv2
//
//  Created by Roen Wainscoat on 10/19/17.
//  Copyright © 2017 Roen Wainscoat. All rights reserved.
//

import UIKit
import MapKit
import Darwin

class ViewController: UIViewController, CLLocationManagerDelegate {
    var latitude: Double?
    var longitude: Double?
    var altitude: Double?
    var lat: String?
    var lon: String?
    var distance: Double?
    let locationManager = CLLocationManager()
    @IBOutlet weak var myLatitude: UITextField!
    @IBOutlet weak var myLongitude: UITextField!
    @IBOutlet weak var evLatitude: UITextField!
    @IBOutlet weak var evLongitude: UITextField!
    @IBOutlet weak var evDistance: UITextField!
    @IBOutlet weak var refresh: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate  = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view, typically from a nib.
        evLoad()
}
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("GPS allowed.")
        }
        else {
            print("GPS not allowed.")
            return
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let myCoordinate = locationManager.location?.coordinate
        altitude = locationManager.location?.altitude
        latitude = myCoordinate?.latitude
        longitude = myCoordinate?.longitude
        
        myLatitude.text = String(latitude!)
        myLongitude.text = String(longitude!)
    }
    func evLoad() {
        super.viewDidLoad()
        fetchURL()
       // performSelector(inBackground: #selector(fetchURL), with: nil)
    }
    
    @objc func fetchURL() {
        var data = "00 A 0.0 0.0"
        if let url = URL(string: "https://roen.us/wapps/dev/evn/evn.txt") {
            do {
                data = "7 A 7.0 7.0"
                let data = try String(contentsOf: url)
                let allEvData = data.components(separatedBy: " ")
                evLatitude.text = allEvData[2]
                evLongitude.text = allEvData[3]
                evDistance.text = "33"
                print("Refreshed HTTP")
            } catch {
                // error loading
                data = "9 A 9.0 9.0"
                let data = data.components(separatedBy: " ")
                evLatitude.text = data[1]
                evLongitude.text = data[2]
            }
        } else {
            // url bad
            data = "4 A 4.0 4.0"
        }
//        data = "2 A 2.0 2.0"
    }
     
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

