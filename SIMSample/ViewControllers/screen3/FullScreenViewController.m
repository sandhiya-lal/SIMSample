//
//  FullScreenViewController.m
//  SIMSample
//
//  Created by einfochips on 11/4/17.
//  Copyright © 2017 einfochips. All rights reserved.
//

#import "FullScreenViewController.h"

@interface FullScreenViewController ()<KIImagePagerDelegate, KIImagePagerDataSource>

{
	NSArray * imageNameArray;
	IBOutlet KIImagePager *_imagePager;
	CGFloat lastScale;
}
@property(nonatomic,strong)	NSString * selString;
@end

@implementation FullScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	imageNameArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"imagesReferences"]];

}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	_imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
	_imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
	_imagePager.slideshowShouldCallScrollToDelegate = YES;
	[_imagePager setCurrentPage:self.selectedImage animated:NO];

}

#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
	return imageNameArray;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager
{
	return UIViewContentModeScaleAspectFit;
}

#pragma mark - KIImagePager Delegate
- (void) imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
	NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}

- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
	NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) imagePager:(KIImagePager *)imagePager didLongPressImageAtIndex:(NSUInteger)index {
	NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	NSString *selectedImageURL = [imageNameArray objectAtIndex:index];
	pasteboard.string = selectedImageURL;
	
}

- (void) imagePager:(KIImagePager *)imagePager didZoomImageAtIndex:(NSUInteger)index {
	NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}


- (void)handlePinchGesture:(UIPinchGestureRecognizer *)gestureRecognizer {
	
	if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
		// Reset the last scale, necessary if there are multiple objects with different scales.
		lastScale = [gestureRecognizer scale];
	}
	
	if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
		[gestureRecognizer state] == UIGestureRecognizerStateChanged) {
		
		CGFloat currentScale = [[[gestureRecognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
		
		const CGFloat kMaxScale = 2.0;
		const CGFloat kMinScale = 1.0;
		
		CGFloat newScale = 1 -  (lastScale - [gestureRecognizer scale]); 
		newScale = MIN(newScale, kMaxScale / currentScale);
		newScale = MAX(newScale, kMinScale / currentScale);
		CGAffineTransform transform = CGAffineTransformScale([[gestureRecognizer view] transform], newScale, newScale);
		[gestureRecognizer view].transform = transform;
		
		lastScale = [gestureRecognizer scale];  // Store the previous. scale factor for the next pinch gesture call
	}
}

@end
