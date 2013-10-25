//
//  ViewController.h
//  TableViewThreadingBlocks
//
//  Created by Jackie Karira on 10/20/13.
//  Copyright (c) 2013 Jackie Karira. All rights reserved.
//

//  Simple app that uses Flickr to display thumbnails based on a search term.
//  When the user clicks on any of the cells a new view pops up with a bigger frame for the image.
//  The user can then press 'Done' to dismiss the new view
//

#import <UIKit/UIKit.h>


@interface MainScreenViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, NSURLConnectionDataDelegate, UITextFieldDelegate>

@property (atomic)    NSMutableArray *photoArray;
@property (nonatomic) UICollectionView *photoCollectionView;
@property (nonatomic) UIView *detailView;

//function that handles image view animationwhen done button is clicked
-(void)doneButtonCliked;

@end
