//
//  FlickrController.h
//  TableViewThreadingBlocks
//
//  Created by Jackie Karira on 10/20/13.
//  Copyright (c) 2013 Jackie Karira. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "FlickrPhoto.h"

typedef void (^SearchDataBlock)(NSString *searchTerm, NSArray *results, NSError *error);
typedef void (^PhotoDownloadBlock)(UIImage *photoImage, NSError *error);
typedef void (^ThumbnailDownloadBlock)(NSUInteger index);

@interface FlickrController : NSObject

-(void) getSearchData:(NSString*)searchTerm completionBlock:(SearchDataBlock)block;
-(void) getThumbnailImages:(NSArray*)imageArray completionBlock:(ThumbnailDownloadBlock)block;
+ (NSString *)flickrSearchURLForSearchTerm:(NSString *) searchTerm;
+ (NSString *)flickrPhotoURLForFlickrPhoto:(FlickrPhoto *) flickrPhoto size:(NSString *) size;

@end
