//
//  ImageGalleryViewController.m
//  SIMSample
//
//  Created by einfochips on 11/4/17.
//  Copyright © 2017 einfochips. All rights reserved.
//

#import "ImageGalleryViewController.h"
#import "FullScreenViewController.h"

@interface ImageGalleryViewController ()
{
	NSArray *imageNameArray;
	NSInteger selectedItemIndex;
	UIActivityIndicatorView *activityIndicator;
}
@property (nonatomic, strong) UIStoryboardSegue *segue;
@end



@implementation ImageGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
	collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
	[collectionView setDataSource:self];
	[collectionView setDelegate:self];
	
	[collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
	[collectionView setBackgroundColor:[UIColor grayColor]];
	
	[self.view addSubview:collectionView];
	self.title = @"Gallery";
	
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.alpha = 1.0;
	[collectionView addSubview:activityIndicator];
	activityIndicator.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height/2);
	[activityIndicator startAnimating];
	
	[self getImageListFromAPI];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return imageNameArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return CGSizeMake((self.view.frame.size.width- 20) /3, (self.view.frame.size.width- 20)/3);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
	
	UIImageView *imgview = (UIImageView *)[cell viewWithTag:100];
	imgview = [[UIImageView alloc]initWithFrame:CGRectMake(3,3,((self.view.frame.size.width- 20)/3)-6,((self.view.frame.size.width- 20)/3)-6)];
	NSString *url = [imageNameArray objectAtIndex:indexPath.row];
	NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];

	imgview.image = [UIImage imageWithData:imgData];
	[cell.contentView addSubview:imgview];
	
	return cell;
	
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	selectedItemIndex = indexPath.row;
	NSInteger selectedItem = selectedItemIndex;
	FullScreenViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"FullScreenViewController"];
	vc.selectedImage = selectedItem;
	[self.navigationController pushViewController:vc animated:YES];	
}

- (void) getImageListFromAPI
{
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"https://private-e1b8f4-getimages.apiary-mock.com/getImages"]];
	[request setHTTPMethod:@"GET"];
	
	NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
	[[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
		imageNameArray = [json objectForKey:@"pugs"];
	
		//>>>>>>tumblr images were blocked here. SO I tested using dummy images.
		
//		imageNameArray = [NSArray arrayWithObjects:@"https://voxy.com/wp-content/uploads/2012/10/school-1.jpg", @"https://voxy.com/wp-content/uploads/2012/10/school-1.jpg",@"https://voxy.com/wp-content/uploads/2012/10/school-1.jpg", @"https://voxy.com/wp-content/uploads/2012/10/school-1.jpg",
//							nil];
		[[NSUserDefaults standardUserDefaults] setObject:imageNameArray forKey:@"imagesReferences"];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[collectionView reloadData];
		});
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[activityIndicator stopAnimating];
			[activityIndicator setHidden:YES];
			 NSLog(@"loaded completely:reload finished");
			
		});
		
		
	}] resume];
}

@end
