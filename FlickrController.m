//
//  FlickrController.m
//  TableViewThreadingBlocks
//
//  Created by Jackie Karira on 10/20/13.
//  Copyright (c) 2013 Jackie Karira. All rights reserved.
//

#import "FlickrController.h"

#define kFlickrAPIKey @"d02c877c0a4220890f14fc95f8b16983"

@implementation FlickrController

+ (NSString *)flickrSearchURLForSearchTerm:(NSString *) searchTerm
{
    searchTerm = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&per_page=20&format=json&nojsoncallback=1",kFlickrAPIKey,searchTerm];
}

-(void)getSearchData:(NSString *)searchTerm completionBlock:(SearchDataBlock)block
{
    //create search URL
    NSString *searchURL = [FlickrController flickrSearchURLForSearchTerm:searchTerm];
    
    NSURL *url = [NSURL URLWithString:searchURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //download json data for images
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            block(searchTerm,nil,connectionError);
        }
        else
        {
            // Parse the JSON Response
            NSError *error = nil;
            NSDictionary *searchResultsDict = [NSJSONSerialization JSONObjectWithData:data
                                                                              options:kNilOptions
                                                                                error:&error];
            if(error != nil)
            {
                block(searchTerm,nil,error);
            }
            else
            {
                NSString * status = searchResultsDict[@"stat"];
                if ([status isEqualToString:@"fail"]) {
                    NSError * error = [[NSError alloc] initWithDomain:@"FlickrSearch" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: searchResultsDict[@"message"]}];
                    block(searchTerm, nil, error);
                } else {
                    //store json data into FlickrPhoto objects
                    NSArray *objPhotos = searchResultsDict[@"photos"][@"photo"];
                    NSMutableArray *flickrPhotos = [@[] mutableCopy];
                    for(NSMutableDictionary *objPhoto in objPhotos)
                    {
                        FlickrPhoto *photo = [[FlickrPhoto alloc] init];
                        photo.farm = [objPhoto[@"farm"] intValue];
                        photo.server = [objPhoto[@"server"] intValue];
                        photo.secret = objPhoto[@"secret"];
                        photo.photoID = [objPhoto[@"id"] longLongValue];
                        
                        [flickrPhotos addObject:photo];
                    }
                    
                    block(searchTerm,flickrPhotos,nil);
                }
            }
        }
    }];


}

+ (NSString *)flickrPhotoURLForFlickrPhoto:(FlickrPhoto *) flickrPhoto
{
    NSString *size = @"m";
    
    return [NSString stringWithFormat:@"http://farm%d.staticflickr.com/%d/%lld_%@_%@.jpg",flickrPhoto.farm,flickrPhoto.server,flickrPhoto.photoID,flickrPhoto.secret,size];
}

-(void)getThumbnailImages:(NSArray *)imageArray completionBlock:(ThumbnailDownloadBlock)block
{
    //enumerate over photo array with data and download images
    [imageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *searchURL = [FlickrController flickrPhotoURLForFlickrPhoto:obj];
        NSURL *url = [NSURL URLWithString:searchURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            UIImage *image = [UIImage imageWithData:data];
            ((FlickrPhoto*)obj).thumbnail = image;
            block(idx);
        }];
    }];
}

@end
