//
//  ViewController.swift
//  Map Kit Local Search Study
//
//  Created by Ömer Faruk Kılıçaslan on 7.05.2022.
//

import UIKit
import MapKit
class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var aramaBar: UISearchBar!
    
    let istek = MKLocalSearch.Request()
    override func viewDidLoad() {
        super.viewDidLoad()

        aramaBar.delegate = self
        mapView.delegate = self
        
        let konum = CLLocationCoordinate2D(latitude: 41.03, longitude: 28.97)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        
        let bolge = MKCoordinateRegion(center: konum, span: span)
        
        mapView.setRegion(bolge, animated: true)
        
        istek.region = mapView.region
        
    }


}

extension ViewController: MKMapViewDelegate, UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        istek.naturalLanguageQuery = searchBar.text!
        
        if mapView.annotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
            
        }
        
        let arama = MKLocalSearch(request: istek)
        arama.start(completionHandler: { (response,error ) in
            if error != nil {
                print("Hata")
            }
            else if response!.mapItems.count == 0{
                print("Mekan yok")
            }
            else{
                for mekan in response!.mapItems {
                    
                    if let ad = mekan.name, let tel = mekan.phoneNumber {
                        print("Ad : \(ad)")
                        print("Tel : \(tel)")
                        print("Enlem : \(mekan.placemark.coordinate.latitude)")
                        print("Boylam : \(mekan.placemark.coordinate.longitude)")
                        
                        let pin = MKPointAnnotation()
                        pin.coordinate = mekan.placemark.coordinate
                        
                        pin.title = ad
                        pin.subtitle = tel
                        self.mapView.addAnnotation(pin)
                    }
                    
                }
            }
            
        })
    }
}
