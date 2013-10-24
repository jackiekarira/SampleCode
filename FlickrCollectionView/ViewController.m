//
//  ViewController.m
//  TableViewThreadingBlocks
//
//  Created by Jackie Karira on 10/20/13.
//  Copyright (c) 2013 Jackie Karira. All rights reserved.
//

#import "ViewController.h"
#import "FlickrPhoto.h"
#import "FlickrPhotoCollectionView.h"
#import "FlickrPhotoCollectionViewCell.h"
#import "FlickrController.h"

#define kCellId @"photoCellId"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) loadView
{
    
    [super loadView];
    
    //setup view
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //setup textfield
    
    UILabel *searchLabel = [[UILabel alloc] init];
    searchLabel.text = @"Search:";
    searchLabel.textColor = [UIColor whiteColor];
    searchLabel.backgroundColor = [UIColor clearColor];
    searchLabel.frame = CGRectMake(60, 20, 100, 20);
    [self.view addSubview:searchLabel];
    
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(130, 20, 150, 20)];
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    searchField.font = [UIFont systemFontOfSize:15];
    searchField.placeholder = @"enter text";
    searchField.keyboardType = UIKeyboardTypeDefault;
    searchField.returnKeyType = UIReturnKeyDone;
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.delegate = self;
    [self.view addSubview:searchField];
    
    //create collection view
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    layout.minimumInteritemSpacing = 12.0f;
    self.photoCollectionView = [[FlickrPhotoCollectionView alloc] initWithFrame:CGRectMake(0, 50, 320, 430) collectionViewLayout:layout];
    self.photoCollectionView.backgroundColor = [UIColor whiteColor];
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self;
    [self.photoCollectionView registerClass:[FlickrPhotoCollectionViewCell class] forCellWithReuseIdentifier:kCellId];
    [self.view addSubview:self.photoCollectionView];
    [self.photoCollectionView setBackgroundColor:[UIColor grayColor]];
    
    //initialize photo array
    self.photoArray = [[NSMutableArray alloc] initWithObjects:nil];
    
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//setting up the cell in the collection view
- (FlickrPhotoCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = kCellId;
    FlickrPhotoCollectionViewCell* newCell = [self.photoCollectionView dequeueReusableCellWithReuseIdentifier:cellId
                                                                                                 forIndexPath:indexPath];
    
    FlickrPhoto *flickrPhoto = [self.photoArray objectAtIndex:indexPath.row];
    newCell.photo.image = flickrPhoto.thumbnail;
    newCell.photo.frame = CGRectMake(5, 5, newCell.frame.size.width - 10, newCell.frame.size.height - 10);
    return newCell;
}

//function called when user clicks on a cell in the collectionview
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlickrPhoto *flickrPhoto = [self.photoArray objectAtIndex:indexPath.row];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.detailView = [[UIView alloc] initWithFrame:CGRectMake(screenBounds.size.width/2 - 110, screenBounds.size.height, 220, 220)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:flickrPhoto.thumbnail];
    imgView.backgroundColor = [UIColor whiteColor];
    [self.detailView addSubview:imgView];
    self.detailView.backgroundColor = [UIColor whiteColor];
    imgView.frame = CGRectMake(20, 20, self.detailView.frame.size.width - 40, self.detailView.frame.size.height - 40);
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [doneButton addTarget:self action:@selector(doneButtonCliked) forControlEvents:UIControlEventTouchDown];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.backgroundColor = [UIColor clearColor];
    doneButton.titleLabel.backgroundColor = [UIColor clearColor];
    doneButton.titleLabel.textColor = [UIColor blueColor];
    doneButton.frame = CGRectMake(0, 0, 50, 20);
    [self.detailView addSubview:doneButton];
    [self.view addSubview:self.detailView];
    [UIView animateWithDuration:0.5 animations:^{
        self.detailView.frame = CGRectMake(screenBounds.size.width/2 - 110, screenBounds.size.height/2 - 110, 220, 220);
    }];
    [self.photoCollectionView setUserInteractionEnabled:NO];
}

//callback for when user presses return on keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //close text input
    [textField resignFirstResponder];
    
    [self.photoArray removeAllObjects];
    [self.photoCollectionView reloadData];
    
    //download json data about images
    FlickrController *flick = [[FlickrController alloc] init];
    [flick getSearchData:[textField text] completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
        
        [self.photoArray removeAllObjects];
        [self.photoArray addObjectsFromArray:results];
        
        //download thumbnail images from json data
        [flick getThumbnailImages:self.photoArray completionBlock:^(NSUInteger index) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                //reload cells that have the image downloaded
                [self.photoCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
            });
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //reload collectionview when json data downloads
            [self.photoCollectionView reloadData];
        });
    }];
    return YES;
}


//callback for done button
-(void)doneButtonCliked
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [UIView animateWithDuration:0.5 animations:^{
        self.detailView.frame = CGRectMake(screenBounds.size.width/2 - 110, screenBounds.size.height, 220, 220);
    } completion:^(BOOL finished) {
        [self.photoCollectionView setUserInteractionEnabled:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
