//  
// Copyright (c) 2019 Loverde Co.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
 

import Foundation

#if os(iOS) || os(macOS)
import UIKit
import CoreLocation
import MapKit
import Contacts

@objc public protocol LocationDelegate: class {
    
    @objc(manager: region:)
    optional func location(manager: CLLocationManager, didStartMonitoringFor region: CLRegion)
    
    @objc(manager:)
    optional func location(managerDidPauseLocationUpdates manager: CLLocationManager)
    
    @objc(manager:)
    optional func location(managerDidResumeLocationUpdates manager: CLLocationManager)
    
    @objc(manager: error:)
    optional func location(manager: CLLocationManager, didFailWithError error: Error)
    
    @objc(manager: locations:)
    optional func location(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    
    @objc(manager: status:)
    optional func location(manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
}

public struct Address {
    var completeAddress: String!
    var country: String!
    var state: String!
    var city: String!
    var neightboor: String!
    var street: String!
    var zipCode: String!
    var rangeNumbers: String!
    var latitude: String!
    var longitude: String!
    var addresses: [Address]!
    
    init(){
        
    }
}

open class Location: NSObject, CLLocationManagerDelegate {
    
    private var locationManager = CLLocationManager()
    weak var delegate: LocationDelegate!
    var address: Address!
    var allAddress: [Address] = [Address]()
    public var location: CLLocation?
    static var permited: Bool = false
    static let shared = Location()
    
    override init() {
        super.init()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        }
    }
    
    public func requestPermissions(completion:@escaping ((Bool)->Void)){
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.notDetermined {
            //locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            Location.permited = false
            completion(false)
        }else{
            Location.permited = true
            completion(true)
        }
    }
    
    public func searchForAddress(address: String, completion:@escaping (([Address]?, Error?)->Void)){
        getLatLonFrom(address: address) { (coordinate, error) in
            if error != nil {
                completion(nil, error)
            }else{
                self.getAddressFrom(latitude: "\((coordinate?.coordinate.latitude)!)", andLongitude: "\((coordinate?.coordinate.longitude)!)", completion: { (returnedAddress, error) in
                    if error != nil {
                        completion(nil, error)
                    }else{
                        completion(returnedAddress!.addresses, nil)
                    }
                })
            }
        }
    }
    
    public func getAddressFrom(latitude: String, andLongitude longitude: String, completion:@escaping ((Address?, Error?)->Void)) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(latitude)")!
        let lon: Double = Double("\(longitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) in
            if (error != nil){
                completion(nil, error!)
            }else{
                (placemarks! as [CLPlacemark]).forEach({ (places) in
                    var address = Address()
                    address.country = places.country!
                    address.state = places.administrativeArea!
                    address.city = places.locality!
                    if let neightboor = places.subLocality {
                        address.neightboor = neightboor
                    }else{
                        address.neightboor = ""
                    }
                    if let street = places.thoroughfare {
                        address.street = street
                    }else{
                        address.street = ""
                    }
                    //var zipCodeFinal = ""
                    
                    //                    if let zipFinal = places.subThoroughfare {
                    //                        zipCodeFinal = "-"+zipFinal
                    //                    }
                    if let postalCode = places.postalCode {
                        address.zipCode = postalCode //+zipCodeFinal
                    }else{
                        address.zipCode = ""
                    }
                    if let range = places.subThoroughfare {
                        address.rangeNumbers = range
                    }
                    address.latitude = latitude
                    address.longitude = longitude
                    address.completeAddress = "\((address.street)!), \((address.neightboor)!), \((address.city)!) - \((address.state)!), \((address.country)!), \((address.zipCode)!)"
                    self.allAddress.append(address)
                })
                self.address = self.allAddress.first!
                self.address.addresses = self.allAddress
                Location.shared.address = self.address
                Location.shared.address.addresses = self.allAddress
                completion(self.address, nil)
            }
        })
    }
    
    public func getLatLonFrom(address: String, isoCountryCode: String = "BR", completion:@escaping ((CLLocation?, NSError?)->Void)) {
        let geoCoder = CLGeocoder()
        
        if #available(iOS 11.0, *) {
            let postalAddress = CNMutablePostalAddress()
            postalAddress.postalCode = address
            postalAddress.isoCountryCode = isoCountryCode
            
            geoCoder.geocodePostalAddress(postalAddress) { (placemarks, error) in
                guard let founded = placemarks, let location = founded.first?.location else {
                    let error = NSError(domain: LCEssentials().DEFAULT_ERROR_DOMAIN, code: LCEssentials().DEFAULT_ERROR_CODE, userInfo: [ NSLocalizedDescriptionKey: "Endereço não encontrado." ])
                    completion(nil, error)
                    return
                }
                completion(location, nil)
            }
        }else{
            let params: [String: Any] = [
                CNPostalAddressPostalCodeKey: address,
                CNPostalAddressISOCountryCodeKey: isoCountryCode
            ]
            
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                if let locais = placemarks {
                    guard let location = locais.first?.location else {
                        let error = NSError(domain: LCEssentials().DEFAULT_ERROR_DOMAIN, code: LCEssentials().DEFAULT_ERROR_CODE, userInfo: [ NSLocalizedDescriptionKey: "Endereço não encontrado." ])
                        completion(nil, error)
                        return
                    }
                    completion(location, nil)
                }else{
                    geoCoder.geocodeAddressDictionary(params) { (placemarks, error) in
                        guard let founded = placemarks, let location = founded.first?.location else {
                            let error = NSError(domain: LCEssentials().DEFAULT_ERROR_DOMAIN, code: LCEssentials().DEFAULT_ERROR_CODE, userInfo: [ NSLocalizedDescriptionKey: "Endereço não encontrado." ])
                            completion(nil, error)
                            return
                        }
                        completion(location, nil)
                    }
                }
            }
        }
    }
    
    func alertaLocal(){
        if delegate is UIViewController {
            let controller = delegate as! UIViewController
            let alert = UIAlertController(title: "Settings", message: "Para acessar seu GPS, precisa liberar o acesso nas configurações.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Vamos lá!", style: .cancel, handler: { action in
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            }))
            alert.addAction(UIAlertAction(title: "Por enquanto não", style: .destructive, handler: nil))
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    public static func openLocationOnMap(lat: Double, lon: Double, sourceName: String?, destinationName: String?){
        let coordinates = CLLocationCoordinate2DMake(lat, lon)
        var array = [MKMapItem]()
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)))
        if let destName = destinationName {
            destination.name = destName
        }
        array.append(destination)
        var sourceMap: MKMapItem?
        if let source = sourceName {
            sourceMap = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)))
            sourceMap!.name = source
            array.append(sourceMap!)
        }
        MKMapItem.openMaps(with: array, launchOptions: [:])
    }
    
    func stop(){
        locationManager.stopUpdatingLocation()
    }
    
    open func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        if delegate != nil { delegate.location?(manager: manager, didStartMonitoringFor: region) }
    }
    
    open func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        if delegate != nil { delegate.location?(managerDidPauseLocationUpdates: manager) }
    }
    
    open func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        if delegate != nil { delegate.location?(managerDidResumeLocationUpdates: manager) }
    }
    
    open func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        printError(title: "LOCATION", msg: "ERROR: \(error.localizedDescription)")
        //alertaLocal()
        if delegate != nil { delegate.location?(manager: manager, didFailWithError: error) }
    }
    
    open func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let located = locations.first {
            self.location = located
            Location.shared.location = located
            //printWarn(title: "LOCATION", msg: "UPDATING LOCATION: \(located)")
        }
        if delegate != nil { delegate.location?(manager: manager, didUpdateLocations: locations) }
    }
    
    open func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.notDetermined {
            Location.permited = false
        }else{
            Location.permited = true
            locationManager.startUpdatingLocation()
            //Location.shared.location = locationManager.location
        }
        //printInfo(title: "LOCATION", msg: "MUDEI A AUTORIZACAO! \(Location.permited)")
        if delegate != nil { delegate.location?(manager: manager, didChangeAuthorization: status) }
    }
    deinit {
        locationManager.stopMonitoringSignificantLocationChanges()
    }
}
#endif
