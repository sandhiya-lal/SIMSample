//
//  ContactsListViewController.h
//  SIMSample
//
//  Created by einfochips on 11/2/17.
//  Copyright © 2017 einfochips. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsListViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableViewContactData;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *addEmergencyContacts;

@end
