# MapboxDirections

[📱&nbsp;![iOS Build Status](https://www.bitrise.io/app/2f82077d3f083479.svg?token=mC783nGMKA3XrvcMCJAOLg&branch=master)](https://www.bitrise.io/app/2f82077d3f083479) &nbsp;&nbsp;&nbsp;
[🖥💻&nbsp;![macOS Build Status](https://www.bitrise.io/app/3e18d5c284ee7fe4.svg?token=YCPg5FTvNCSoRBvECdFWtg&branch=master)](https://www.bitrise.io/app/3e18d5c284ee7fe4) &nbsp;&nbsp;&nbsp;
[📺&nbsp;![tvOS Build Status](https://www.bitrise.io/app/0dd69f13a42252d6.svg?token=jin7-oeLn35GfZqWaqumtA&branch=master)](https://www.bitrise.io/app/0dd69f13a42252d6) &nbsp;&nbsp;&nbsp;
[⌚️&nbsp;![watchOS Build Status](https://www.bitrise.io/app/6db52b89a8fbfb40.svg?token=v645xdLSJWX0uYxLU7CA3g&branch=master)](https://www.bitrise.io/app/6db52b89a8fbfb40)

MapboxDirections.swift makes it easy to connect your iOS, macOS, tvOS, or watchOS application to the [Mapbox Directions API](https://www.mapbox.com/directions/). Quickly get driving, cycling, or walking directions, whether the trip is nonstop or it has multiple stopping points, all using a simple interface reminiscent of MapKit’s `MKDirections` API. The Mapbox Directions API is powered by the [OSRM](http://project-osrm.org/) routing engine and open data from the [OpenStreetMap](https://www.openstreetmap.org/) project.

Despite its name, MapboxDirections.swift works in Objective-C and Cocoa-AppleScript code in addition to Swift 3.

MapboxDirections.swift pairs well with [MapboxGeocoder.swift](https://github.com/mapbox/MapboxGeocoder.swift), [MapboxStatic.swift](https://github.com/mapbox/MapboxStatic.swift), and the [Mapbox iOS SDK](https://www.mapbox.com/ios-sdk/) or [macOS SDK](https://github.com/mapbox/mapbox-gl-native/tree/master/platform/macos).

## Getting started

Specify the following dependency in your [CocoaPods](http://cocoapods.org/) Podfile:

```podspec
pod 'MapboxDirections.swift', :git => 'https://github.com/mapbox/MapboxDirections.swift.git', :branch => 'swift3'
```

Or in your [Carthage](https://github.com/Carthage/Carthage) Cartfile:

```cartfile
github "raphaelmor/Polyline" ~> 4.0
github "Mapbox/MapboxDirections.swift" "swift3"
```

Then `import MapboxDirections` or `@import MapboxDirections;`.

This repository includes a example application written in Swift demonstrating how to use the framework. More examples and detailed documentation are available in the [Mapbox API Documentation](https://www.mapbox.com/api-documentation/?language=Swift#directions).

## Usage

You’ll need a [Mapbox access token](https://www.mapbox.com/developers/api/#access-tokens) in order to use the API. If you’re already using the [Mapbox iOS SDK](https://www.mapbox.com/ios-sdk/) or [macOS SDK](https://github.com/mapbox/mapbox-gl-native/tree/master/platform/macos), MapboxDirections.swift automatically recognizes your access token, as long as you’ve placed it in the `MGLMapboxAccessToken` key of your application’s Info.plist file.

### Basics

The main directions class is Directions (in Swift) or MBDirections (in Objective-C or AppleScript). Create a directions object using your access token:

```swift
// main.swift
import MapboxDirections

let directions = Directions(accessToken: "<#your access token#>")
```

```objc
// main.m
@import MapboxDirections;

MBDirections *directions = [[MBDirections alloc] initWithAccessToken:@"<#your access token#>"];
```

```applescript
-- AppDelegate.applescript
set theDirections to alloc of MBDirections of the current application
tell theDirections to initWithAccessToken:"<#your access token#>"
```

Alternatively, you can place your access token in the `MGLMapboxAccessToken` key of your application’s Info.plist file, then use the shared directions object:

```swift
// main.swift
let directions = Directions.shared
```

```objc
// main.m
MBDirections *directions = [MBDirections sharedDirections];
```

```applescript
-- AppDelegate.applescript
set theDirections to sharedDirections of MBDirections of the current application
```

With the directions object in hand, construct a RouteOptions or MBRouteOptions object and pass it into the `Directions.calculate(_:completionHandler:)` method.

```swift
// main.swift

let waypoints = [
    Waypoint(coordinate: CLLocationCoordinate2D(latitude: 38.9131752, longitude: -77.0324047), name: "Mapbox"),
    Waypoint(coordinate: CLLocationCoordinate2D(latitude: 38.8977, longitude: -77.0365), name: "White House"),
]
let options = RouteOptions(waypoints: waypoints, profileIdentifier: MBDirectionsProfileIdentifierAutomobile)
options.includesSteps = true

let task = directions.calculate(options) { (waypoints, routes, error) in
    guard error == nil else {
        print("Error calculating directions: \(error!)")
        return
    }
    
    if let route = routes?.first, leg = route.legs.first {
        print("Route via \(leg):")
        
        let distanceFormatter = LengthFormatter()
        let formattedDistance = distanceFormatter.string(fromMeters: route.distance)
        
        let travelTimeFormatter = DateComponentsFormatter()
        travelTimeFormatter.unitsStyle = .short
        let formattedTravelTime = travelTimeFormatter.string(from: route.expectedTravelTime)
        
        print("Distance: \(formattedDistance); ETA: \(formattedTravelTime!)")
        
        for step in leg.steps {
            print("\(step.instructions)")
            let formattedDistance = distanceFormatter.string(fromMeters: step.distance)
            print("— \(formattedDistance) —")
        }
    }
}
```

```objc
// main.m

NSArray<MBWaypoint *> *waypoints = @[
    [[MBWaypoint alloc] initWithCoordinate:CLLocationCoordinate2DMake(38.9131752, -77.0324047) coordinateAccuracy:-1 name:@"Mapbox"],
    [[MBWaypoint alloc] initWithCoordinate:CLLocationCoordinate2DMake(38.8977, -77.0365) coordinateAccuracy:-1 name:@"White House"],
];
MBRouteOptions *options = [[MBRouteOptions alloc] initWithWaypoints:waypoints
                                                  profileIdentifier:MBDirectionsProfileIdentifierAutomobile];
options.includesSteps = YES;

NSURLSessionDataTask *task = [directions calculateDirectionsWithOptions:options
                                                      completionHandler:^(NSArray<MBWaypoint *> * _Nullable waypoints,
                                                                          NSArray<MBRoute *> * _Nullable routes,
                                                                          NSError * _Nullable error) {
    if (error) {
        NSLog(@"Error calculating directions: %@", error);
        return;
    }
    
    MBRoute *route = routes.firstObject;
    MBRouteLeg *leg = route.legs.firstObject;
    if (leg) {
        NSLog(@"Route via %@:", leg);
        
        NSLengthFormatter *distanceFormatter = [[NSLengthFormatter alloc] init];
        NSString *formattedDistance = [distanceFormatter stringFromMeters:leg.distance];
        
        NSDateComponentsFormatter *travelTimeFormatter = [[NSDateComponentsFormatter alloc] init];
        travelTimeFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyleShort;
        NSString *formattedTravelTime = [travelTimeFormatter stringFromTimeInterval:route.expectedTravelTime];
        
        NSLog(@"Distance: %@; ETA: %@", formattedDistance, formattedTravelTime);
        
        for (MBRouteStep *step in leg.steps) {
            NSLog(@"%@", step.instructions);
            NSString *formattedDistance = [distanceFormatter stringFromMeters:step.distance];
            NSLog(@"— %@ —", formattedDistance);
        }
    }
}];
```

```
-- AppDelegate.applescript

set mapbox to alloc of MBWaypoint of the current application
tell mapbox to initWithCoordinate:{38.9131752, -77.0324047} coordinateAccuracy:-1 |name|:"Mapbox"
set theWhiteHouse to alloc of MBWaypoint of the current application
tell theWhiteHouse to initWithCoordinate:{38.8977, -77.0365} coordinateAccuracy:-1 |name|:"White House"
set theWaypoints to {mapbox, theWhiteHouse}

set theOptions to alloc of MBRouteOptions of the current application
tell theOptions to initWithWaypoints:theWaypoints profileIdentifier:"mapbox/driving"
set theOptions's includesSteps to true

set theURL to theDirections's URLForCalculatingDirectionsWithOptions:theOptions
set theData to the current application's NSData's dataWithContentsOfURL:theURL
set theJSON to the current application's NSJSONSerialization's JSONObjectWithData:theData options:0 |error|:(missing value)

set theRoute to alloc of MBRoute of the current application
tell theRoute to initWithJson:(the first item of theJSON's routes) waypoints:theWaypoints profileIdentifier:"mapbox/driving"
set theLeg to the first item of theRoute's legs

log "Route via " & theLeg's |name| & ":"

set theDistanceFormatter to alloc of NSLengthFormatter of the current application
tell theDistanceFormatter to init()
set theDistance to theDistanceFormatter's stringFromMeters:(theLeg's distance)

log "Distance: " & theDistance

repeat with theStep in theLeg's steps
    log theStep's instructions
    set theDistance to theDistanceFormatter's stringFromMeters:(theStep's distance)
    log "— " & theDistance & " —"
end repeat
```

This library uses version 5 of the Mapbox Directions API by default. To use version 4 instead, replace RouteOptions with RouteOptionsV4 (or MBRouteOptions with MBRouteOptionsV4).

### Drawing the route on a map

With the [Mapbox iOS SDK](https://www.mapbox.com/ios-sdk/) or [macOS SDK](https://github.com/mapbox/mapbox-gl-native/tree/master/platform/macos), you can easily draw the route on a map in Swift or Objective-C:

```swift
// main.swift

if route.coordinateCount > 0 {
    // Convert the route’s coordinates into a polyline.
    var routeCoordinates = route.coordinates!
    let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
    
    // Add the polyline to the map and fit the viewport to the polyline.
    mapView.addAnnotation(routeLine)
    mapView.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: .zero, animated: true)
}
```

```objc
// main.m

if (route.coordinateCount) {
    // Convert the route’s coordinates into a polyline.
    CLLocationCoordinate2D *routeCoordinates = malloc(route.coordinateCount * sizeof(CLLocationCoordinate2D));
    [route getCoordinates:routeCoordinates];
    MGLPolyline *routeLine = [MGLPolyline polylineWithCoordinates:routeCoordinates count:route.coordinateCount];
    
    // Add the polyline to the map and fit the viewport to the polyline.
    [mapView addAnnotation:routeLine];
    [mapView setVisibleCoordinates:routeCoordinates count:route.coordinateCount edgePadding:UIEdgeInsetsZero animated:YES];
    
    // Make sure to free this array to avoid leaking memory.
    free(routeCoordinates);
}
```

## Tests

To run the included unit tests, you need to use [CocoaPods](http://cocoapods.org) to install the dependencies. 

1. `pod install`
1. `open MapboxDirections.xcworkspace`
1. Switch to the MapboxDirections scheme and go to Product ‣ Test.

The workspace requires CocoaPods 1.1.0.beta.1 or greater if opening inside Xcode 8.
