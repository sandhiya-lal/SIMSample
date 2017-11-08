//
//  ContactsListTableViewCell.h
//  SIMSample
//
//  Created by einfochips on 11/2/17.
//  Copyright © 2017 einfochips. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *contactName;
@property (strong, nonatomic) IBOutlet UIButton *dialerButton;

@end
