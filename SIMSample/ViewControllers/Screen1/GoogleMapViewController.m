//
//  GoogleMapViewController.m
//  SIMSample
//
//  Created by einfochips on 11/3/17.
//  Copyright © 2017 einfochips. All rights reserved.
//

#import "GoogleMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>


@interface GoogleMapViewController ()<CLLocationManagerDelegate>

@end

@implementation GoogleMapViewController
CLLocationManager *locationManager;
GMSMapView *mapView;
int call ;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	locationManager.distanceFilter = 50;
	call = 0;
	self.title = @"Maps";

}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
	switch (status) {
		case kCLAuthorizationStatusNotDetermined: {
			[locationManager requestWhenInUseAuthorization];
		} break;
		case kCLAuthorizationStatusDenied: {
		} break;
		case kCLAuthorizationStatusAuthorizedWhenInUse:
		case kCLAuthorizationStatusAuthorizedAlways: {
			[locationManager startUpdatingLocation];//Will update location immediately
		} break;
		default:
			break;
	}
}
-(void)showUserLocation {
	
	if (call > 0) {
		return;
	} else {
		call++;
		
		CLLocation *location = [locationManager location];
		CLLocationCoordinate2D coor = [location coordinate];
		GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coor.latitude
										longitude:coor.longitude zoom:17];
		mapView = [GMSMapView mapWithFrame:CGRectMake(0, 55, self.view.frame.size.width, self.view.frame.size.height) camera:camera];
		mapView.myLocationEnabled = YES;
		mapView.settings.allowScrollGesturesDuringRotateOrZoom = YES;
		[self.view addSubview:mapView];
		
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button addTarget:self
				   action:@selector(placeOne)
		 forControlEvents:UIControlEventTouchUpInside];
		[button setTitle:@">>location" forState:UIControlStateNormal];
		[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
		[self.view addSubview:button];
		
		GMSMarker *marker = [[GMSMarker alloc] init];
		marker.position = CLLocationCoordinate2DMake(coor.latitude, coor.longitude);
		marker.map = mapView;
	}
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)placeOne {

	GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:23.012053
															longitude:72.569123199999
																 zoom:17];
	
	mapView = [GMSMapView mapWithFrame:CGRectMake(0, 55, self.view.frame.size.width, self.view.frame.size.height) camera:camera];
	mapView.myLocationEnabled = YES;
	mapView.camera = camera;
	mapView.settings.allowScrollGesturesDuringRotateOrZoom = YES;
	[self.view addSubview:mapView];

	GMSMarker *marker = [[GMSMarker alloc] init];
	marker.position = CLLocationCoordinate2DMake(23.012053, 72.569123199999);
	marker.map = mapView;
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button addTarget:self
			   action:@selector(placeTwo)
	 forControlEvents:UIControlEventTouchUpInside];
	[button setTitle:@">>location" forState:UIControlStateNormal];
	[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
	[self.view addSubview:button];
}

-(void)placeTwo {
	
	GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:23.027383
															longitude:72.5587245999999
																 zoom:17];
	
	mapView = [GMSMapView mapWithFrame:CGRectMake(0, 55, self.view.frame.size.width, self.view.frame.size.height) camera:camera];
	mapView.myLocationEnabled = YES;
	mapView.camera = camera;
	mapView.settings.allowScrollGesturesDuringRotateOrZoom = YES;
	[self.view addSubview:mapView];
	
	GMSMarker *marker = [[GMSMarker alloc] init];
	marker.position = CLLocationCoordinate2DMake(23.027383, 72.5587245999999);
	marker.map = mapView;
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button addTarget:self
			   action:@selector(placeOne)
	 forControlEvents:UIControlEventTouchUpInside];
	[button setTitle:@">>location" forState:UIControlStateNormal];
	[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
	[self.view addSubview:button];
}

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
		  fromLocation:(CLLocation *)oldLocation
{
	[self showUserLocation];
}

@end
