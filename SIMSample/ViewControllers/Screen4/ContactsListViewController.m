//
//  ContactsListViewController.m
//  SIMSample
//
//  Created by einfochips on 11/2/17.
//  Copyright © 2017 einfochips. All rights reserved.
//

#import "ContactsListViewController.h"
#import <Contacts/Contacts.h>
#import "ContactsListTableViewCell.h"


@interface ContactsListViewController ()<UITableViewDataSource,UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate>
{
	NSMutableArray *arrayTableData;
	NSMutableDictionary *contactsListDict;
	NSArray *searchResults;
	NSMutableArray * ImageArray;
	NSMutableArray * emergencyContact;
	UIImage *buttonImage;
}
@property (strong, nonatomic) UISearchController *searchController;


@end

@implementation ContactsListViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
}


-(void)viewWillAppear:(BOOL)animated {
	
	//hide empty cells of uitableview
	self.tableViewContactData.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

	self.addEmergencyContacts.layer.cornerRadius = self.addEmergencyContacts.frame.size.height/2;
	self.addEmergencyContacts.clipsToBounds = YES;
	self.addEmergencyContacts.layer.borderWidth = 0.1;
	self.addEmergencyContacts.layer.borderColor = [UIColor blackColor].CGColor;
	
	
	// Do any additional setup after loading the view.
	arrayTableData = [[NSMutableArray alloc]init];
	
	self.title = @"All contacts";
	contactsListDict = [[NSMutableDictionary alloc]init];
	[self fetchContactsandAuthorization];
	self.tableViewContactData.delegate = self;
	self.tableViewContactData.dataSource = self;
	
	[self.tableViewContactData registerNib:[UINib nibWithNibName:NSStringFromClass([ContactsListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ContactsListTableViewCell class])];
	
	
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
								   initWithTarget:self
								   action:@selector(dismissKeyboard)];
	
	[self.view addGestureRecognizer:tap];
	
	ImageArray=[[NSMutableArray alloc]init];
	emergencyContact = [[NSMutableArray alloc]init];
	
	[[self.scrollView subviews]
	 makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	self.searchController.searchResultsUpdater = self;
	self.searchController.dimsBackgroundDuringPresentation = NO;
	self.searchController.searchBar.delegate = self;
	self.searchController.delegate = self;
	self.tableViewContactData.tableHeaderView.clipsToBounds = true;
	self.searchController.searchBar.placeholder = @"Search your contact";
	
	CALayer *border = [CALayer layer];
	CGFloat borderWidth = 2;
	border.borderColor = [UIColor grayColor].CGColor;

	border.frame = CGRectMake(0, self.searchController.searchBar.frame.size.height - borderWidth, self.view.frame.size.width, self.searchController.searchBar.frame.size.height);
	
	border.borderWidth = borderWidth;
	
	[self.searchController.searchBar.layer addSublayer:border];
	self.searchController.searchBar.layer.masksToBounds = YES;
	self.searchController.searchBar.layer.borderWidth = 0.2;
	self.searchController.searchBar.layer.borderColor = [UIColor grayColor].CGColor;
	self.searchController.searchBar.layer.cornerRadius = 3.0;
	self.searchController.searchBar.barTintColor = [UIColor whiteColor];
	self.searchController.searchBar.backgroundColor = [UIColor clearColor];
	
	[self.view addSubview:self.searchController.searchBar];
	self.definesPresentationContext = YES;
	self.navigationController.navigationBar.translucent= NO;
	
	[[self.scrollView subviews]
	 makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	buttonImage = [UIImage imageNamed:@"call.png"];
	ImageArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"storedEmergencyContacts"];
	
	for (int i = 0; i < ImageArray.count; i++) {
		CGRect frame;
		frame.origin.x = 100 * i;
		frame.origin.y = 0;
		frame.size = self.scrollView.frame.size;
		UIView *subview = [[UIView alloc] initWithFrame:frame];
		
		NSMutableDictionary *arr = [ImageArray objectAtIndex:i];
		NSString *name = [arr objectForKey:@"contactName"];
		NSData *imageData = [arr objectForKey:@"contactImage"];
		
		UIImage *image1 = [NSKeyedUnarchiver unarchiveObjectWithData:imageData];
		if (image1 == nil) {
			image1 = [UIImage imageNamed:@"avatar.png"];
		}
		UIImageView *imageView = [[UIImageView alloc] initWithImage: image1];
		[imageView setFrame:CGRectMake(10, 5, 80,80 )];
		
		imageView.layer.cornerRadius = imageView.frame.size.height/2;
		imageView.clipsToBounds = YES;
		imageView.layer.borderWidth = 0.1;
		imageView.layer.borderColor = [UIColor blackColor].CGColor;
		
		UILabel *countLabel = [[UILabel alloc] init];
		countLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 80, 20)];
		countLabel.textAlignment = NSTextAlignmentCenter;
		countLabel.text = name;
		countLabel.font=[UIFont boldSystemFontOfSize:15.0];
		countLabel.textColor=[UIColor blackColor];
		countLabel.backgroundColor=[UIColor clearColor];
		[subview addSubview:countLabel];
		[subview addSubview:imageView];
		[self.scrollView addSubview:subview];
	}

	self.scrollView.contentSize = CGSizeMake((100 * ImageArray.count) + 10, self.scrollView.frame.size.height);

	self.scrollView.contentOffset=CGPointMake (0, 0);
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[self.searchController.searchBar subviews]
	 makeObjectsPerformSelector:@selector(removeFromSuperview)];
}



- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
	NSString *searchString = searchController.searchBar.text;
	[self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
	[self.tableViewContactData reloadData];
}

- (void)searchForText:(NSString*)searchText scope:(NSInteger)scope
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contactName contains[c] %@",searchText];
	searchResults = [[NSMutableArray alloc] initWithArray: [[arrayTableData filteredArrayUsingPredicate:predicate]copy]];
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if ([searchText isEqualToString: @""]) {
		[self.searchController setActive:false];
	}
	
	[self updateSearchResultsForSearchController:self.searchController];
	

}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
	[self updateSearchResultsForSearchController:self.searchController];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
		if (self.searchController.isActive) {
			return [searchResults count];
			
		} else {
			return  arrayTableData.count;
			
		}

	
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 75.0f;
	
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	

	NSDictionary *contactInfo = [[NSDictionary alloc] init];
	if (self.searchController.isActive) {
		contactInfo = searchResults[indexPath.row];
		
	}else {
		contactInfo = arrayTableData[indexPath.row];
	}
	
	ContactsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContactsListTableViewCell class]) forIndexPath:indexPath];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	//disable the uitableview highlighting 
	
	cell.contactName.text = [contactInfo objectForKey:@"contactName"];
		cell.profileImage.image = [contactInfo objectForKey:@"contactImage"];
	[cell.dialerButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
	
	cell.dialerButton.tag = indexPath.row;
	[cell.dialerButton addTarget:self action:@selector(dialerClicked:) forControlEvents:UIControlEventTouchUpInside];
	return cell;

}


-(void)dialerClicked:(UIButton*)sender
{
	
	
	NSInteger selectedIndexPath = sender.tag;
	NSDictionary *contactInfo = [[NSDictionary alloc] init];
	if (self.searchController.isActive) {
		contactInfo = searchResults[selectedIndexPath];
	}else {
		contactInfo = arrayTableData[selectedIndexPath];
	}

	NSString *phoneCallNum = [NSString stringWithFormat:@"tel://%@",[contactInfo objectForKey:@"contactPhone"] ];
	NSString *cleanedPhoneNum = [[phoneCallNum componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:cleanedPhoneNum]];
}

//This is for fetching contacts from iPhone.Also It asks authorization permission.
-(void)fetchContactsandAuthorization
{
	// Request authorization to Contacts
	CNContactStore *store = [[CNContactStore alloc] init];
	[store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
		if (granted == YES)
		{
			//keys with fetching properties
			NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
			NSString *containerId = store.defaultContainerIdentifier;
			NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
			NSError *error;
			NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
			if (error)
			{
				NSLog(@"error fetching contacts %@", error);
			}
			else
			{
				NSString *phone;
				NSString *fullName;
				NSString *firstName;
				NSString *lastName;
				UIImage *profileImage;
				NSMutableArray *contactNumbersArray = [[NSMutableArray alloc]init];
				for (CNContact *contact in cnContacts) {
					// copy data to my custom Contacts class.
					firstName = contact.givenName;
					lastName = contact.familyName;
					if (lastName == nil) {
						fullName=[NSString stringWithFormat:@"%@",firstName];
					}else if (firstName == nil){
						fullName=[NSString stringWithFormat:@"%@",lastName];
					}
					else{
						fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
					}
					UIImage *image = [UIImage imageWithData:contact.imageData];
					if (image != nil) {
						profileImage = image;
					}else{
						profileImage = [UIImage imageNamed:@"avatar.png"];
					}
					for (CNLabeledValue *label in contact.phoneNumbers) {
						phone = [label.value stringValue];
						if ([phone length] > 0) {
							[contactNumbersArray addObject:phone];
						}
					}
				
					
					contactsListDict = [NSMutableDictionary dictionaryWithCapacity:1];
					if (phone != nil) {
					[contactsListDict setObject:phone forKey:@"contactPhone"];
					}
					else {
						[contactsListDict setObject:@"0000000000" forKey:@"contactPhone"];
					}
					[contactsListDict setObject:profileImage forKey:@"contactImage"];
					if (fullName != nil) {
					[contactsListDict setObject:fullName forKey:@"contactName"];
					}
					else {
						[contactsListDict setObject:@"Unknown" forKey:@"contactName"];
					}
					
					[arrayTableData addObject:contactsListDict];
				}
				dispatch_async(dispatch_get_main_queue(), ^{
					[self.tableViewContactData reloadData];
				});
			}
		}
	}];
}
- (void) dismissKeyboard
{
	[self.searchController.searchBar resignFirstResponder];
}
- (IBAction)addEmergencyContactClicked:(id)sender {
	NSLog(@"add emergency clicked");

}



@end

