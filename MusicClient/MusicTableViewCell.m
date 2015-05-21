//
//  MusicTableViewCell.m
//  MusicClient
//
//  Created by Alexey Boyko on 21.05.15.
//  Copyright (c) 2015 Alexey Boyko. All rights reserved.
//

#import "MusicTableViewCell.h"
#import "UIImageView+Downoad.h"

@interface MusicTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *albumCover;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *artist;

@end

@implementation MusicTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMelody:(NSDictionary *)melody
{
    _title.text = [melody objectForKey:@"title"];
    _artist.text = [melody objectForKey:@"artist"];
    NSString* picURL = [melody objectForKey:@"picUrl"];
    [_albumCover downloadImageWithURLstring:picURL];
    _demoURL = [melody objectForKey:@"demoUrl"];
}

@end
