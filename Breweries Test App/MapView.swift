//
//  MapView.swift
//  Breweries Test App
//
//  Created by Dmytro Nechuyev on 15.06.2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    var centerCoordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
     
        view.mapType = MKMapType.standard
        
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        view.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = centerCoordinate
        view.addAnnotation(annotation)
    }

}
