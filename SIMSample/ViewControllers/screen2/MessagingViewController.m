//
//  MessagingViewController.m
//  SIMSample
//
//  Created by einfochips on 11/5/17.
//  Copyright © 2017 einfochips. All rights reserved.
//

#import "MessagingViewController.h"
#import "MessagingTableViewCell.h"

@interface MessagingViewController ()<UITableViewDataSource,UITableViewDelegate, UITextViewDelegate
>
{
	NSMutableArray *messagesArray;
}

@end

@implementation MessagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.messagingTableView.delegate = self;
	self.messagingTableView.dataSource = self;
	
	[self.messagingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessagingTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MessagingTableViewCell class])];
	
	//custom colour
	UIColor *hueGrayColour = [[UIColor alloc]initWithRed:(179/255.0) green:(175/255.0) blue:(162/255.0) alpha:1];
	self.view.backgroundColor = hueGrayColour;
	self.messagingTableView.backgroundColor = hueGrayColour;
	self.messagingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	//dark brown colour //customize segment control
	UIColor *darkBrownColour = [[UIColor alloc]initWithRed:(70/255.0) green:(28/255.0) blue:(12/255.0) alpha:1];
	
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
								[UIFont boldSystemFontOfSize:17], NSFontAttributeName,
								 darkBrownColour, NSForegroundColorAttributeName,
								nil];
	[self.segmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
	NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
	[self.segmentControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
	self.segmentControl.tintColor =  darkBrownColour;
	CGRect frame= self.segmentControl.frame;
	[self.segmentControl setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 100)];
	
	//get messages from API
	[self getMessageList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	//added bg image to nav-bar
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-image.png"] forBarMetrics:UIBarMetricsDefault];
	self.title = @"Messaging";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return messagesArray.count;
	
	
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 190.0f;
	
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//custom messaging table view cell
	 MessagingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MessagingTableViewCell class]) forIndexPath:indexPath];
	
	//used custom fonts opensans
	cell.messageLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
	
	UIColor *hueGrayColour = [[UIColor alloc]initWithRed:(179/255.0) green:(175/255.0) blue:(162/255.0) alpha:1];
	cell.backgroundColor = hueGrayColour;
	
	//if got response from API
	if (messagesArray.count > 0) {
	NSMutableDictionary *messageData = [messagesArray objectAtIndex:indexPath.row];
	
	cell.messageTypeLabel.text = [messageData valueForKey:@"name"];
	
	NSString *screenNameValue =  [messageData valueForKey:@"screenName"];
	NSString *s = @"@";
	s = [s stringByAppendingString:screenNameValue];
	cell.messageTypeReferenceLabel.text = s;
	
		//date formatting
	NSString *messageDate = [messageData valueForKey: @"Original_Post_DateTime"];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *date  = [dateFormatter dateFromString:messageDate];
		
		// Convert to new Date Format
	[dateFormatter setDateFormat:@"EEE MMM dd HH:mm"];
	NSString *newDate = [dateFormatter stringFromDate:date];
	cell.dateTimeLabel.text = newDate;
		
		
	NSString *socialTypeValue = [messageData valueForKey:@"social_type"];
	NSString *q = @"via ";
	q = [q stringByAppendingString:socialTypeValue];
	cell.mediaLabel.text = q;

	cell.messageLabel.text =[messageData valueForKey:@"tweet"];
	}
	cell. selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
	
}

- (void) getMessageList
{
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://private-71386-getmessagestest.apiary-mock.com/get_messages"]];
	[request setHTTPMethod:@"GET"];
	
	NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
	[[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
			messagesArray = [json objectForKey:@"data"];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.messagingTableView reloadData];
		});
		
	}] resume];
}


@end
