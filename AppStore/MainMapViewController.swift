//
//  MainMapViewController.swift
//  AppStore
//
//  Created by Jonathan Archille on 1/26/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//



import UIKit
import GoogleMaps
import GooglePlaces
import Toucan
import Material

class MainMapViewController: UIViewController, GMSMapViewDelegate, ProfileImageDelgate {
    
    static var rallyPoint: CLLocationCoordinate2D?
    
    var currentMarker: GMSMarker = {
        let marker = GMSMarker()
        marker.icon = Toucan(image: #imageLiteral(resourceName: "down_arrow")).resize(CGSize(width: 20, height: 32), fitMode: Toucan.Resize.FitMode.crop).image
        return marker
    }()
    
    let apiHandler = APIHandler()
    
    let darkOverlay = UIView()
    
    let overlayHeight: CGFloat = 160.0
    
    var mainMapView: GMSMapView?
    
    lazy var infoBoxView: InfoBoxView = {
        let view = Bundle.main.loadNibNamed("InfoBoxView", owner: self, options: nil)?.first as! InfoBoxView
        return view
    }()
    
    var bottomConstraint: NSLayoutConstraint!
    
    var tappedBusiness: Business! {
        didSet {
            MainMapViewController.rallyPoint = tappedBusiness.coordinates
            DispatchQueue.main.async {
                self.infoBoxView.addressLabel.text = self.tappedBusiness.address
                self.infoBoxView.locationNameLabel.text = self.tappedBusiness.name
                self.infoBoxView.categoriesLabel.text = self.tappedBusiness.categories
            }
        }
    }
    
    
    func updateImage(image: UIImage) {
        DispatchQueue.main.async {
            self.infoBoxView.locationImageView.image = Toucan(image: image).resize(CGSize(width: 120, height: 120), fitMode: Toucan.Resize.FitMode.clip).image
        }
    }
    
    var picker: UIDatePicker!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 28.540846, longitude: -81.379086, zoom: 16.0)
        mainMapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mainMapView?.settings.myLocationButton = false
        mainMapView?.settings.compassButton = true
        mainMapView?.delegate = self
        view.addSubview(mainMapView!)
        
        tappedBusiness = Business(name: "", address: "", category: "", imageUrl: "", coordinates: CLLocationCoordinate2D(latitude: 28.4741414, longitude: -81.3091644))
        
        
        setupViews()
        
        apiHandler.delegate = self
         
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

    
    
    //Mark: - View Animations
    
    
    var isVisible = false
    
    
    func toggleInfoBox() {
        
        if isVisible == false {
            print("not visible")
            self.bottomConstraint.isActive = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                
                self.bottomConstraint.constant = 0
                self.view.layoutIfNeeded()
                
                
            })
            self.bottomConstraint.isActive = true
            isVisible = true
        }
    }
    
    
    
    
    
}

extension MainMapViewController: infoBoxViewDelegate, GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.dismiss(animated: true, completion: nil)
        
        
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
        
        mainMapView?.camera = camera
        
        currentMarker.position = place.coordinate
        
        MainMapViewController.rallyPoint = place.coordinate
    
        
        
        
        
        
        apiHandler.searchYelp(coordinates: place.coordinate, completion: { (result, error) in
            
            self.tappedBusiness = result
            
        })
        
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("\(error)")
    }
    
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func openSearch() {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        self.present(autoCompleteController, animated: true, completion: nil)
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        if isVisible == false {
            toggleInfoBox()
        }
        
        currentMarker.position = coordinate
        currentMarker.map = self.mainMapView
        apiHandler.searchYelp(coordinates: coordinate, completion: { (result, error) in
            
            self.tappedBusiness = result
            
            DispatchQueue.main.async {
                //self.toggleInfoBox()
                
            }
            
        })
        
        
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        apiHandler.searchYelp(coordinates: location, completion: { (result, error) in
            
            self.tappedBusiness = result
            
            DispatchQueue.main.async {
                //self.toggleInfoBox()
            }
            
        })
        
    }
    

        
        func setupViews() {
            
            infoBoxView.delegate = self
            infoBoxView.translatesAutoresizingMaskIntoConstraints = false
            
            
            view.addSubview(infoBoxView)
            infoBoxView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            infoBoxView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
            infoBoxView.heightAnchor.constraint(equalToConstant: 160).isActive = true
            bottomConstraint = infoBoxView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: infoBoxView.frame.height)
            bottomConstraint!.isActive = true
            
            let searchButton = FabButton(image: #imageLiteral(resourceName: "search"))
            searchButton.pulseColor = .white
            searchButton.backgroundColor = UIColor.rgb(redValue: 50, greenValue: 73, blueValue: 100, alpha: 0.8)
            searchButton.addTarget(self, action: #selector(openSearch), for: .touchUpInside)
            
            let groupCreateButton = FabButton(image: Toucan(image: UIImage(named: "add_group")!).resizeByScaling(CGSize(width: 30, height: 30)).image)
            groupCreateButton.backgroundColor = UIColor.rgb(redValue: 50, greenValue: 73, blueValue: 100, alpha: 0.8)
            groupCreateButton.addTarget(self, action: #selector(showGroupCreateTVC), for: .touchUpInside)
            
            view.layout(searchButton).width(45).height(45).center(offsetX: 150, offsetY: -225)
            view.layout(groupCreateButton).width(45).height(45).center(offsetX: 150, offsetY: -163)
            
            apiHandler.searchYelp(coordinates: CLLocationCoordinate2D(latitude: 28.4741414, longitude: -81.3091644), completion: { (result, error) in
                
                self.tappedBusiness = result
                
                DispatchQueue.main.async {
                    //self.toggleInfoBox()
                }
            })
        }

        
        func showGroupSelectTVC() {
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            
            let containerView = self.view.window
            containerView?.layer.add(transition, forKey: nil)
            present(UINavigationController(rootViewController: GroupSelectViewController()), animated: false, completion: nil)
            
            
        }
    
    func showGroupCreateTVC() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        
        let containerView = self.view.window
        containerView?.layer.add(transition, forKey: nil)
        present(UINavigationController(rootViewController: GroupCreateTVC()), animated: false, completion: nil)

    }
    
    func dismissView() {
            print("Tap received")
            
        }
    
}


