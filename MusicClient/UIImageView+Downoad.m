//
//  UIImageView+Downoad.m
//
//  Created by Alexey Boyko on 01.05.15.
//  Copyright (c) 2015 Alexey Boyko. All rights reserved.
//

#import "UIImageView+Downoad.h"

@implementation UIImageView (Downoad)

- (void)downloadImageWithURLstring:(NSString*)urlString
{
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ( !error )
             self.image = [[UIImage alloc] initWithData:data];
     }];
}

@end
