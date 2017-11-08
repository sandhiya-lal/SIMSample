//
//  GoogleMapViewController.h
//  SIMSample
//
//  Created by einfochips on 11/3/17.
//  Copyright © 2017 einfochips. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GoogleMapViewController : UIViewController <CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UIView *mapView;
@property (strong, nonatomic) IBOutlet UITextField *serachFeild;

@end
