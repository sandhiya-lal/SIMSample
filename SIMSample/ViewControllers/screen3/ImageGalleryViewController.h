//
//  ImageGalleryViewController.h
//  SIMSample
//
//  Created by einfochips on 11/4/17.
//  Copyright © 2017 einfochips. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageGalleryViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
	UICollectionView *collectionView;
}

@end
