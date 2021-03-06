//
//  MusicTableViewCell.h
//  MusicClient
//
//  Created by Alexey Boyko on 21.05.15.
//  Copyright (c) 2015 Alexey Boyko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicTableViewCell : UITableViewCell

- (void)setMelody:(NSDictionary*)melody;

@property (nonatomic, strong) NSString* demoURL;

@end
