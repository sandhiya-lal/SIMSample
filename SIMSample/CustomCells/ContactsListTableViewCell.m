//
//  ContactsListTableViewCell.m
//  SIMSample
//
//  Created by einfochips on 11/2/17.
//  Copyright © 2017 einfochips. All rights reserved.
//

#import "ContactsListTableViewCell.h"

@implementation ContactsListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
	self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
	self.profileImage.clipsToBounds = YES;
	self.profileImage.layer.borderWidth = 0.1;
	self.profileImage.layer.borderColor = [UIColor blackColor].CGColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
