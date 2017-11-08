//
//  MessagingTableViewCell.m
//  SIMSample
//
//  Created by einfochips on 11/6/17.
//  Copyright © 2017 einfochips. All rights reserved.
//

#import "MessagingTableViewCell.h"

@implementation MessagingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	self.messageView.layer.cornerRadius = 10;
	self.messageView.clipsToBounds = YES;
	self.messageView.backgroundColor = [UIColor whiteColor];
	UIColor *darkRed = [[UIColor alloc]initWithRed:(161/255.0) green:(42/255.0) blue:(42/255.0) alpha:1];
	[self.dateTimeLabel setTextColor:darkRed];
	[self.mediaLabel setTextColor:darkRed];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
