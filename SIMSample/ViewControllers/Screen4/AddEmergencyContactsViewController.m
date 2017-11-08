//
//  AddEmergencyContactsViewController.m
//  SIMSample
//
//  Created by einfochips on 11/3/17.
//  Copyright © 2017 einfochips. All rights reserved.
//

#import "AddEmergencyContactsViewController.h"
#import <Contacts/Contacts.h>
#import "ContactsListTableViewCell.h"

@interface AddEmergencyContactsViewController ()<UITableViewDataSource,UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate>
{
	NSMutableArray *arrayTableData;
	NSMutableDictionary *contactsListDict;
	NSArray *searchResults;
	NSMutableArray * emergencyContact;
	UIImage *addToEmergencyImage;
	UIImage *removeFromEmergencyImage;
	
}
@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation AddEmergencyContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	self.searchController.searchResultsUpdater = self;
	self.searchController.dimsBackgroundDuringPresentation = NO;
	self.searchController.searchBar.delegate = self;
	self.searchController.delegate = self;
	self.allContactsTable.tableHeaderView.clipsToBounds = true;
	
	[self.view addSubview:self.searchController.searchBar];
	self.definesPresentationContext = YES;
	self.navigationController.navigationBar.translucent= NO;
	addToEmergencyImage = [UIImage imageNamed:@"add.png"];
	removeFromEmergencyImage = [UIImage imageNamed:@"remove.png"];
	
	// Do any additional setup after loading the view.
	arrayTableData = [[NSMutableArray alloc]init];
	
	self.title = @"Add emergency contacts";
	contactsListDict = [[NSMutableDictionary alloc]init];
	[self fetchContactsandAuthorization];
	self.allContactsTable.delegate = self;
	self.allContactsTable.dataSource = self;
	self.searchController.searchBar.placeholder = @"search your contact";
	
	
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
	
	
	
	[self.allContactsTable registerNib:[UINib nibWithNibName:NSStringFromClass([ContactsListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ContactsListTableViewCell class])];
	
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
								   initWithTarget:self
								   action:@selector(dismissKeyboard)];
	
	[self.view addGestureRecognizer:tap];

	//hide empty cells of uitableview
	self.allContactsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[self.searchController.searchBar subviews]
	 makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
	NSString *searchString = searchController.searchBar.text;
	[self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
	[self.allContactsTable reloadData];
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
	cell.contactName.text = [contactInfo objectForKey:@"contactName"];
	cell.profileImage.image = [contactInfo objectForKey:@"contactImage"];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	//disable the uitableview highlighting
	
	
	[cell.dialerButton setBackgroundImage:addToEmergencyImage forState:UIControlStateNormal];

	NSString *exist  = [contactInfo objectForKey:@"existInEMergency"];
	if ([exist isEqualToString:@"EXIST"]) {
		[cell.dialerButton setBackgroundImage:removeFromEmergencyImage forState:UIControlStateNormal];
	}
	
	cell.dialerButton.tag = indexPath.row;
	[cell.dialerButton addTarget:self action:@selector(dialerClicked:) forControlEvents:UIControlEventTouchUpInside];
	return cell;
	
}


-(void)dialerClicked:(UIButton*)sender
{
	NSMutableArray *mutableArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"storedEmergencyContacts"];

	NSInteger selectedIndexPath = sender.tag;
	NSDictionary *contactInfo = [[NSDictionary alloc] init];
	if (self.searchController.isActive) {
		contactInfo = searchResults[selectedIndexPath];
	}else {
		contactInfo = arrayTableData[selectedIndexPath];
	}

	NSString *exist  = [contactInfo objectForKey:@"existInEMergency"];
	if ([exist isEqualToString:@"EXIST"]) {
		NSLog(@"RAVII");
		NSMutableArray *emergencyList = [[[NSUserDefaults standardUserDefaults] objectForKey:@"storedEmergencyContacts"] mutableCopy];
		for (int i= 0; i< emergencyList.count; i++) {
			
			if ([[emergencyList[i] objectForKey:@"contactName"] isEqualToString: [contactInfo objectForKey:@"contactName"]] && [[emergencyList[i] objectForKey:@"contactPhone"] isEqualToString: [contactInfo objectForKey:@"contactPhone"]]) {
				[emergencyList removeObjectAtIndex:i];
				[[NSUserDefaults standardUserDefaults] setObject:emergencyList forKey:@"storedEmergencyContacts"];
				[[NSUserDefaults standardUserDefaults] synchronize];
				break;
			}
		}
	}
	else {
	
	NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
	[tempDic setObject:[contactInfo objectForKey:@"contactName"] forKey:@"contactName"];
	[tempDic setObject:[contactInfo objectForKey:@"contactPhone"] forKey:@"contactPhone"];
		
	UIImage *img =  [contactInfo objectForKey:@"contactImage"];
	UIImage *img2 = [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:img.imageOrientation];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:img];
	
	[tempDic setObject:data forKey:@"contactImage"];
	
	NSMutableArray *billsArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"storedEmergencyContacts"]];
	[billsArr addObject:tempDic];
	[[NSUserDefaults standardUserDefaults] setObject:billsArr forKey:@"storedEmergencyContacts"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	
	[self fetchContactsandAuthorization];
}
-(void)fetchContactsandAuthorization
{
	// Request authorization to Contacts
	arrayTableData = [[NSMutableArray alloc] init];
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
				NSString *existInEMergency;
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
					existInEMergency = @"NOTEXIST";
					
					emergencyContact = [[NSUserDefaults standardUserDefaults]objectForKey:@"storedEmergencyContacts"];
					for (int i= 0; i<emergencyContact.count; i++) {
						if ([fullName isEqualToString: [[emergencyContact objectAtIndex:i] valueForKey:@"contactName"]] &&  [phone isEqualToString: [[emergencyContact objectAtIndex:i] valueForKey:@"contactPhone"]]) {
							existInEMergency = @"EXIST";
							break;
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
					[contactsListDict setObject:existInEMergency forKey:@"existInEMergency"];
					if (fullName != nil) {
						[contactsListDict setObject:fullName forKey:@"contactName"];
					}
					else {
						[contactsListDict setObject:@"Unknown" forKey:@"contactName"];
					}
					
					[arrayTableData addObject:contactsListDict];
				}
				dispatch_async(dispatch_get_main_queue(), ^{
					[self.allContactsTable reloadData];
				});
			}
		}
	}];
}
- (void) dismissKeyboard
{
	[self.searchController.searchBar resignFirstResponder];
}
@end
