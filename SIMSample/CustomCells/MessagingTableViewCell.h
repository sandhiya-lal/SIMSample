//
//  MessagingTableViewCell.h
//  SIMSample
//
//  Created by einfochips on 11/6/17.
//  Copyright © 2017 einfochips. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagingTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *messageView;
@property (strong, nonatomic) IBOutlet UILabel *messageTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageTypeReferenceLabel;

@property (strong, nonatomic) IBOutlet UITextView *messageLabel;

@property (strong, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *mediaLabel;

@end
