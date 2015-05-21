//
//  AudioPlayer.m
//  MusicClient
//
//  Created by Alexey Boyko on 21.05.15.
//  Copyright (c) 2015 Alexey Boyko. All rights reserved.
//

#import "AudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer()

@property (nonatomic, strong) AVAudioPlayer* player;

@end

@implementation AudioPlayer

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred;
    static id shared = nil;
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

- (instancetype)initUniqueInstance
{
    self = [super init];
    if (self != nil)
    {
        // do initialization here
    }
    return self;
}

- (void)playURL:(NSString *)url
{
    [self stop];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSError* error;
        _player = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
        if (_player != nil)
        {
            [_player prepareToPlay];
            [_player play];
        }
        else
        {
            NSLog(@"audio player error: %@", error);
        }
    });
}

- (void)stop
{
    if (_player != nil)
    {
        [_player stop];
        _player = nil;
    }
}

@end
