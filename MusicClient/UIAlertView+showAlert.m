//
//  UIAlertView+showAlert.m
//
//  Created by Alexey Boyko on 06.10.14.
//  Copyright (c) 2014 Alexey Boyko. All rights reserved.
//

#import "UIAlertView+showAlert.h"

@implementation UIAlertView (showAlert)

+ (void)showAlert:(NSString*)message
{
    if (message != nil)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
