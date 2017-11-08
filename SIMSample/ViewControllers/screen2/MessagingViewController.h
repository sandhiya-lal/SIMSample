//
//  MessagingViewController.h
//  SIMSample
//
//  Created by einfochips on 11/5/17.
//  Copyright © 2017 einfochips. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *messagingTableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end
