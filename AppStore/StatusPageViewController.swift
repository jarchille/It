//
//  StatusPageViewController.swift
//  AppStore
//
//  Created by Jonathan Archille on 2/2/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit
import MapboxDirections
import MapboxNavigation
import Mapbox
import CoreLocation
import AVFoundation
import Material
import Toucan


class StatusPageViewController: UIViewController, MGLMapViewDelegate {

    let myHouseCoords = CLLocationCoordinate2DMake(28.4741414, -81.3091644)
    let ironYardCoords = CLLocationCoordinate2DMake(28.540941, -81.381257)
    
    let sourceIdentifier = "sourceIdentifier"
    let layerIdentifier = "layerIdentifier"
    
    let token = "pk.eyJ1IjoiYWNlbWFnbnVtMDEiLCJhIjoiY2l5cDExZjBjMDAzMzQ0bnp5MGFybzdvcCJ9.Mjwd1Arnk7B_F6HNsPpFOQ"
    
    var mapView: MGLMapView!
    
    var userRoute: Route?
    
    var navigation: RouteController?
    
    
    
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        setupMapNib()
        setupButton()
    
    }
    
    func getRoute(didFinish: (()->())? = nil) {
        
        let directions = Directions(accessToken: token)
    
        let options = RouteOptions(coordinates: [myHouseCoords, ironYardCoords])
        options.includesSteps = true
        options.routeShapeResolution = .full
        options.profileIdentifier = MBDirectionsProfileIdentifierAutomobileAvoidingTraffic
        
        _ = directions.calculate(options) { [weak self] (waypoints, routes, error) in
            guard error == nil else {
                print(error!)
                return
            }
            guard let route = routes?.first else {
                return
            }
            guard let style = self?.mapView.style else {
                return
            }
            
            self?.userRoute = route
            
            // Add destination marker
            let destinationMarker = MGLPointAnnotation()
            destinationMarker.coordinate = route.coordinates!.last!
            self?.mapView.addAnnotation(destinationMarker)
            
            let polyline = MGLPolylineFeature(coordinates: route.coordinates!, count: route.coordinateCount)
            let geoJSONSource = MGLShapeSource(identifier: (self?.sourceIdentifier)!, shape: polyline, options: nil)
            let line = MGLLineStyleLayer(identifier: (self?.layerIdentifier)!, source: geoJSONSource)
            
            // Style the line
            line.lineColor = MGLStyleValue(rawValue: UIColor(red:0.00, green:0.45, blue:0.74, alpha:0.9))
            line.lineWidth = MGLStyleValue(rawValue: 5)
            line.lineCap = MGLStyleValue(rawValue: NSValue(mglLineCap: .round))
            line.lineJoin = MGLStyleValue(rawValue: NSValue(mglLineJoin: .round))
            
            // Add source and layer
            style.addSource(geoJSONSource)
            for layer in style.layers.reversed() {
                if !(layer is MGLSymbolStyleLayer) {
                    style.insertLayer(line, above: layer)
                    break
                }
            }
            
            didFinish?()
        }
    }
    
    func startNavigation(_ route: Route) {
        let camera = mapView.camera
        camera.pitch = 40
        camera.altitude = 400.0
        mapView.setCamera(camera, animated: false)
        mapView.userTrackingMode = .followWithCourse
        navigation = RouteController(route: route)
        navigation?.resume()
    }
    
    func setupMapNib() {
    
        let mapNib = Bundle.main.loadNibNamed("StatusPage", owner: self, options: nil)?.first as! StatusPage
        mapNib.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapNib)
        mapNib.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapNib.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        mapNib.acceptedLabel_0.text = "• Jonathan Archille"
        mapNib.awaitingLabel_0.text = "• Michael Schilling"
        
        mapView = mapNib.mapView
        
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        
        getRoute()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.startNavigation(self.userRoute!)
        }

    }
    
    func setupButton() {
        let button = FabButton(image: Toucan(image: #imageLiteral(resourceName: "placeholder")).resizeByClipping(CGSize(width: 45, height: 45)).image)
        button.addTarget(self, action: #selector(returnToMainMap), for: .touchUpInside)
        button.depthPreset = DepthPreset.depth5
        button.backgroundColor = .clear
        
        view.layout(button).width(45).height(45).center(offsetX: -155, offsetY: 5)

    }
    
    func returnToMainMap() {
        
    let mainMap = MainMapViewController()
    mainMap.modalTransitionStyle = .flipHorizontal
    present(mainMap, animated: true, completion: nil)
    
    }

}

class StatusPage: UIView {

    @IBOutlet weak var mapView: MGLMapView!
    
    @IBOutlet weak var declinedLabel_0: UILabel!
    @IBOutlet weak var declinedLabel_1: UILabel!
    @IBOutlet weak var declinedLabel_2: UILabel!
    @IBOutlet weak var declinedLabel_3: UILabel!
    @IBOutlet weak var declinedLabel_4: UILabel!
    @IBOutlet weak var declinedLabel_5: UILabel!
    
    @IBOutlet weak var acceptedLabel_0: UILabel!
    @IBOutlet weak var acceptedLabel_1: UILabel!
    @IBOutlet weak var acceptedLabel_2: UILabel!
    @IBOutlet weak var acceptedLabel_3: UILabel!
    @IBOutlet weak var acceptedLabel_4: UILabel!
    @IBOutlet weak var acceptedLabel_5: UILabel!
    
    @IBOutlet weak var awaitingLabel_0: UILabel!
    @IBOutlet weak var awaitingLabel_1: UILabel!
    @IBOutlet weak var awaitingLabel_2: UILabel!
    @IBOutlet weak var awaitingLabel_3: UILabel!
    @IBOutlet weak var awaitingLabel_4: UILabel!
    @IBOutlet weak var awaitingLabel_5: UILabel!
    
}
