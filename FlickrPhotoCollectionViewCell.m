//
//  FlickrPhotoCollectionViewCell.m
//  TableViewThreadingBlocks
//
//  Created by Jackie Karira on 10/23/13.
//  Copyright (c) 2013 Jackie Karira. All rights reserved.
//

#import "FlickrPhotoCollectionViewCell.h"

@implementation FlickrPhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.photo = [[UIImageView alloc] init];
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.photo];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
