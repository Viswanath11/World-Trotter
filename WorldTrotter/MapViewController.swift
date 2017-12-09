//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Viswanath Subramani S S on 08/10/17.
//  Copyright © 2017 viswanathsubramaniss. All rights reserved.

// MARK: - khgdhgvbjk
// TODO:
// FIXME:
// !!!:
// ???:


import UIKit
import MapKit

struct Locations {
	let place: String
	let lat: Double
	let long: Double
	
	init(place :String, lat :Double, long :Double) {
		self.place = place
		self.lat = lat
		self.long = long
	}
}

fileprivate var location = [Locations]()


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
	
	func mapTypeChanged(_ segControl: UISegmentedControl) {
		
		switch segControl.selectedSegmentIndex {
		case 0:
			mapView.mapType = .standard
		case 1:
			mapView.mapType = .hybrid
		case 2:
			mapView.mapType = .satellite
		default:
			break
		}
	}
	
	
	func buttonAction(sender: UIButton!) {
		let btnsendtag: UIButton = sender
		if btnsendtag.tag == 1 {
			locationManager.requestWhenInUseAuthorization()
			mapView.showsUserLocation = true
		}
	}
	
	//cycling through pins
	var selectedAnnotationIndex = 0
	
	func iterateLocations(_ button:UIButton) {
		
		//Drop location pins onto map:
		for loc in location {
			let dropPin = MKPointAnnotation()
			dropPin.coordinate = CLLocationCoordinate2DMake(loc.lat, loc.long)
			dropPin.title = loc.place
			mapView.addAnnotation(dropPin)
		}
		
		//check for null
		if !(mapView.annotations.count > 0) {
			return
		}
		
		//back to start annotation if last one:
		if selectedAnnotationIndex == mapView.annotations.count {
			selectedAnnotationIndex = 0
		}
		
		//select pin and animate map:
		let annotation = mapView.annotations[selectedAnnotationIndex]
		let zoomedInCurrentLocation = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 10, 10)
		mapView.setRegion(zoomedInCurrentLocation, animated: true)
		selectedAnnotationIndex += 1
		
	}
	

	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		let zoomedInCurrentLocation = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 10, 10)
		mapView.setRegion(zoomedInCurrentLocation, animated: true)
	}

	
	var mapView: MKMapView!
	var button: UIButton!
	var locationManager: CLLocationManager!
	
	override func loadView() {
		mapView = MKMapView()
		mapView.delegate = self
		view = mapView
		
		
		//appending to arrayList of 'Locations'
		location.append (Locations(place: "Sabarimala", lat: 9.43, long: 77.08))
		location.append(Locations(place: "Mysore", lat: 12.29, long: 79.63))
		location.append(Locations(place: "Mumbai", lat: 19.07, long: 72.87))
		
		
		let margins = view.layoutMarginsGuide
		
		//Localizable Strings
		let standardString = NSLocalizedString("Standard", comment: "Standard Map View")
		let satelliteString = NSLocalizedString("Satellite", comment: "Satellite Map View")
		let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid Map View")
		let cycleLocationsString = NSLocalizedString("Cycle Locations", comment: "loop Locations")
		let myLocationString = NSLocalizedString("My Location", comment: "User Location")
		//SEGMENT CONTROL
		let segmentedControl = UISegmentedControl(items: [standardString, satelliteString, hybridString])
		segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
		segmentedControl.selectedSegmentIndex = 0
		segmentedControl.translatesAutoresizingMaskIntoConstraints = false
		//What happens when segmentControl is tapped? calling Action method in #selector
		segmentedControl.addTarget(self, action: #selector( MapViewController.mapTypeChanged(_ :)), for: .valueChanged)
		view.addSubview(segmentedControl)
		
		
		//defining segmentControl constraints using the underlying View's layout margins
		
		let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
		let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
		let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
		topConstraint.isActive = true
		leadingConstraint.isActive = true
		trailingConstraint.isActive = true
		
		
		locationManager = CLLocationManager()
		locationManager.delegate = self
		//Button to show MY LOCATION
		let button: UIButton = UIButton(type: .roundedRect)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = UIColor.gray
		button.tintColor = UIColor.white
		button.layer.cornerRadius = 4.0
		button.setTitle(myLocationString, for: .normal)
		//What happens when button is tapped? #selector(action)
		button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
		button.tag = 1
		view.addSubview(button)
		
		let buttonTopConstraint = button.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8)
		let buttonTrailingConstraint = button.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
		buttonTopConstraint.isActive = true
		buttonTrailingConstraint.isActive = true
		
		
		//Button to cycle/iterate Pinned Locations
		let cycleLocationsButton = UIButton(type: .system)
		cycleLocationsButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
		cycleLocationsButton.tintColor = UIColor.white
		cycleLocationsButton.setTitle(cycleLocationsString, for: .normal)
		cycleLocationsButton.layer.cornerRadius = 4.0
		cycleLocationsButton.backgroundColor = UIColor.gray
		cycleLocationsButton.translatesAutoresizingMaskIntoConstraints = false
		cycleLocationsButton.addTarget(self, action: #selector(iterateLocations(_:)), for: .touchUpInside)
		self.view.addSubview(cycleLocationsButton)
		
		
		let cycleLocationsButtonTopConstarint = cycleLocationsButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8)
		let cycleLocationsButtonLeadingConstraint = cycleLocationsButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
		cycleLocationsButtonTopConstarint.isActive = true
		cycleLocationsButtonLeadingConstraint.isActive = true
		
		
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		//print("Loaded MapViewController's View!")
	}

}
