//
//  MapViewController.swift
//  MapTempConverter
//
//  Created by Kaeny Ito-Cole on 2/28/16.
//  Copyright © 2016 Kaeny Ito-Cole. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    override func loadView() {
        //create a map view
        mapView = MKMapView()
        mapView.delegate = self
        locationManager = CLLocationManager()
        
        //set it as *the* view for this controller
        view = mapView
        
        //add segmented control at the top
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        let segmentedControl = UISegmentedControl(items: [standardString, hybridString, satelliteString])
        segmentedControl.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: "mapTypeChanged:", forControlEvents: .ValueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: 8)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        
        topConstraint.active = true
        leadingConstraint.active = true
        trailingConstraint.active = true
        
        //add location button
        let showLocButton = UIButton(type: .System)
        showLocButton.setTitle("Show Location", forState: .Normal)
        showLocButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(showLocButton)
        
        showLocButton.addTarget(self, action: "showLocButton:", forControlEvents: .TouchUpInside)
        
        let buttonTopConstraint = showLocButton.topAnchor.constraintEqualToAnchor(segmentedControl.bottomAnchor, constant:  8)
        let buttonLeadingConstraint = showLocButton.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        let buttonTrailingConstraint = showLocButton.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        
        buttonTopConstraint.active = true
        buttonLeadingConstraint.active = true
        buttonTrailingConstraint.active = true

        
    }
    
    func mapTypeChanged(segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .Standard
        case 1:
            mapView.mapType = .Hybrid
        case 2:
            mapView.mapType = .Satellite
        default:
            break;
        }
    }
    
    func showLocButton(sender: UIButton!) {
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        let zoomedInCurrentLocation = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
        mapView.setRegion(zoomedInCurrentLocation, animated: true)
    }
    
    override func viewDidLoad() {
        //Always call the super implementation of viewDidLoad
        super.viewDidLoad()
        
    }
}
