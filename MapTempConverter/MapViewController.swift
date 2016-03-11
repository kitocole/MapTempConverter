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

        //gesture recognizer for mkannotation
        let longPress = UILongPressGestureRecognizer(target: self, action: "addAnnotation:")
        longPress.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPress)
        
        //add button to remove annotations
        let removePinButton = UIButton(type: .System)
        removePinButton.setTitle("Remove pins", forState: .Normal)
        removePinButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(removePinButton)
        
        removePinButton.addTarget(self, action: "removePins:", forControlEvents: .TouchUpInside)
        
        let pinButtonBottomConstraint = removePinButton.bottomAnchor.constraintEqualToAnchor(margins.bottomAnchor)
        let pinButtonTrailingConstraint = removePinButton.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        let pinButtonLeadingConstraint = removePinButton.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        
        pinButtonBottomConstraint.active = true
        pinButtonLeadingConstraint.active = true
        pinButtonTrailingConstraint.active = true
        
        
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
    
    func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            let touchPoint = gestureRecognizer.locationInView(mapView)
            let newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            var titleArray = [String]()
            var subtitleArray = [String]()
        
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude), completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }
            
                if placemarks!.count > 0 {
                    let pm = placemarks![0]
                
                    //not all places have thoroughdare & subthoroughfare so validate those value
                    let title = pm.thoroughfare! + "," + pm.subThoroughfare!
                    let subtitle = pm.subLocality
                
                    titleArray.append(title)
                    subtitleArray.append(subtitle!)
                    annotation.title = title
                    annotation.subtitle = subtitle
                    self.mapView.addAnnotation(annotation)
                    print(pm)
                }
            
            })
        }
    }
    
    func removePins(sender: UIButton!) {
        let annotationsToRemove = mapView.annotations.filter{ $0 !== mapView.userLocation}
        mapView.removeAnnotations(annotationsToRemove)
    }
    
    func showLocButton(sender: UIButton!) {
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        let zoomedInCurrentLocation = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
        mapView.setRegion(zoomedInCurrentLocation, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
            
            if annotation is MKUserLocation {
                //return nil so map view draws "blue dot" for standard user location
                return nil
            }
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.animatesDrop = true
                pinView!.draggable = true
                pinView!.pinTintColor = UIColor.blueColor()
            }
            else {
                pinView!.annotation = annotation
            }
        
        let deleteButton = UIButton(type: .Custom) as UIButton!
        deleteButton.frame.size.width = 44
        deleteButton.frame.size.height = 44
        deleteButton.layer.cornerRadius = 5
        deleteButton.backgroundColor = UIColor.redColor()
        deleteButton.setImage(UIImage(named: "trash"), forState: .Normal)
        
        pinView?.leftCalloutAccessoryView = deleteButton
            
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation
        mapView.removeAnnotation(annotation!)
        
    }
    
    
    override func viewDidLoad() {
        //Always call the super implementation of viewDidLoad
        super.viewDidLoad()
        
    }
}
