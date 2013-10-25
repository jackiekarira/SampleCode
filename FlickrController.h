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

// get json data based on search term
// searchTerm - Term used to find images
// completionBlock - Block where actions are performed after data download
-(void)getSearchData:(NSString*)searchTerm completionBlock:(SearchDataBlock)block;

//get thumbnail images based on a search result
//imageArray - Array of FlickrPhoto objects
//completionBlock - Block where actions are performed after thumbnail downloads
-(void)getThumbnailImages:(NSArray*)imageArray completionBlock:(ThumbnailDownloadBlock)block;

//Generate flickr search URL from searchTerm
//searchTerm - Term used to find images
+ (NSString *)flickrSearchURLForSearchTerm:(NSString *) searchTerm;

//Get the flickr photo URL for photo
//flickPhoto - Pointer to the flickr photo object
+ (NSString *)flickrPhotoURLForFlickrPhoto:(FlickrPhoto *) flickrPhoto;

@end
