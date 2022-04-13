//
//  LocationManager.swift
//  Yuball
//
//  Created by iMac on 30/07/21.
//

import CoreLocation
import UIKit.UIApplication
import FirebaseMessaging

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    private let geocoder = CLGeocoder()
    private var locationView = UIView.getView(viewT: LocationPopUpView.self)
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var isLocationAuthorized = false

    // MARK: - Location Manager
    private var locationManager = CLLocationManager()
    
    //MARK:- Method
    
    func setupLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied ||  !CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            locationView = UIView.getView(viewT: LocationPopUpView.self)
            openXIB(XIB: locationView)
            SignUPVM.shared.isGeoLocation = "0"
            
        } else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            isLocationAuthorized = true
            SignUPVM.shared.isGeoLocation = "1"
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func getLocationString(completion: @escaping ((String?) -> Void)) {
        let loc = CLLocation(latitude:  AppPrefsManager.shared.getLatitude(), longitude: AppPrefsManager.shared.getlongitude())
        geocoder.reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) in
            if error == nil {
                let placemark = placemarks?[0]
                var finalAddress = String()
                
                if placemark?.locality != nil {
                    finalAddress = finalAddress + ("\(placemark!.locality ?? "")")
                }
               
                if placemark?.subLocality != nil {
                    finalAddress = finalAddress + (", \(placemark!.subLocality ?? "")")
                }
                completion(finalAddress)
            } else {
                completion(nil)
            }
        })
    }
}

// MARK: - CLLocationManager Delegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        setupLocationManager()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        let location : CLLocation = locations[0]
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
        AppPrefsManager.shared.saveLatitude(Latitude: latitude)
        AppPrefsManager.shared.savelongitude(longitude: longitude)
    
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("CLLocationManager didFailWithError error: \(error.localizedDescription)")
    }
}
