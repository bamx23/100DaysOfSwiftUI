//
//  MapView.swift
//  BucketList
//
//  Created by Nikolay Volosatov on 12/1/19.
//  Copyright © 2019 BX23. All rights reserved.
//

import SwiftUI
import YandexMapKit

struct MapView: UIViewRepresentable {
//    class Coordinator: NSObject, YMKDelegate {
//        var parent: MapView
//
//        init(_ parent: MapView) {
//            self.parent = parent
//        }
//
//        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//            print(mapView.centerCoordinate)
//        }
//
//        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
//            view.canShowCallout = true
//            return view
//        }
//    }

    func makeUIView(context: UIViewRepresentableContext<MapView>) -> YMKMapView {
        let mapView = YMKMapView()

        let mapObjects = mapView.mapWindow.map.mapObjects

        let annotation = mapObjects.addPlacemark(with: YMKPoint(latitude: 51.5, longitude: 0.13))
        annotation.isDraggable = false
        
//        mapView.delegate = context.coordinator

//        let annotation = MKPointAnnotation()
//        annotation.title = "London"
//        annotation.subtitle = "Capital of England"
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: 0.13)
//        mapView.addAnnotation(annotation)

        return mapView
    }

    func updateUIView(_ uiView: YMKMapView, context: UIViewRepresentableContext<MapView>) {

    }

//    func makeCoordinator() -> MapView.Coordinator { .init(self) }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
