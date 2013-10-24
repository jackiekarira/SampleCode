//
//  FlickrPhoto.h
//  Flickr Search
//
//  Created by Jackie Karira on 10/20/13.
//  Copyright (c) 2013 Jackie Karira. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPhoto : NSObject
@property(nonatomic,strong) UIImage *thumbnail;
@property(nonatomic,strong) UIImage *largeImage;

// Lookup info
@property(nonatomic) long long photoID;
@property(nonatomic) NSInteger farm;
@property(nonatomic) NSInteger server;
@property(nonatomic,strong) NSString *secret;

@end
