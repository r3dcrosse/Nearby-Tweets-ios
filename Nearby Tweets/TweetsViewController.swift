//
//  TweetsViewController.swift
//  Nearby Tweets
//
//  Created by David Wayman on 12/2/15.
//  Copyright © 2015 David Wayman. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit
import CoreLocation

class TweetsViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var signedInLabel: UILabel!
    @IBOutlet weak var printLocationButton: UIButton!
    // Part of getting location, declare global variable
    private var locationManager = CLLocationManager()
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Get location:
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(session!.userName)");
            } else {
                print("error: \(error!.localizedDescription)");
            }
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
        
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if (session != nil) {
                print("signed in as \(session!.userName)");
                self.signedInLabel.text = "Signed in as \(session!.userName)"
                
            } else {
                print("error: \(error!.localizedDescription)");
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Location triggered callback 1
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError: \(error.description)")
        let errorAlert = UIAlertView(title: "Error", message: "Failed to Get Your Location", delegate: nil, cancelButtonTitle: "Ok")
        errorAlert.show()
    }
    
    // Location triggered callback 2
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]!) {
        let newLocation = locations.last as CLLocation!
        
        longitude = newLocation.coordinate.longitude
        latitude = newLocation.coordinate.latitude
    }
    
    @IBAction func printLocation(sender: AnyObject) {
        print(latitude , longitude)
        latitudeLabel.text = "latitude: \(latitude)"
        longitudeLabel.text = "longitude: \(longitude)"
        
        userDefaults.setDouble(latitude, forKey: "latitude")
        userDefaults.setDouble(longitude, forKey: "longitude")
        userDefaults.synchronize()
    }

}

