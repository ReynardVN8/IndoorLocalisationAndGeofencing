//
//  ViewController.swift
//  IndoorLocalisationAndGeofencing
//
//  Created by Reynard Vincent Nata on 17/09/19.
//  Copyright © 2019 Reynard Vincent Nata. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var distanceReading: UILabel!
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "CB10023F-A318-3394-4199-A8730C7C1AEC")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 222, minor: 155, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            updateDistance(beacons[0].proximity)
        } else {
            updateDistance(.unknown)
        }
    }
    
    func updateDistance(_ distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "Not Detected"
                
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "Beacon Far"
                
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "Beacon Near"
                
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "Beacon Right Here"
            }
        }
    }

}

// CB10023F-A318-3394-4199-A8730C7C1AEC
// Major 222
// Minor 155
