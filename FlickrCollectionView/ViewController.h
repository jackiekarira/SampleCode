//
//  ViewController.h
//  TableViewThreadingBlocks
//
//  Created by Jackie Karira on 10/20/13.
//  Copyright (c) 2013 Jackie Karira. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlickrPhotoCollectionView;
@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, NSURLConnectionDataDelegate, UITextFieldDelegate>

@property (atomic) NSMutableArray *photoArray;
@property (nonatomic) FlickrPhotoCollectionView *photoCollectionView;
@property (nonatomic) UIView *detailView;

-(void)doneButtonCliked;

@end
