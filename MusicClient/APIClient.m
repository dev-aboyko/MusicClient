//
//  APIClient.m
//  MusicClient
//
//  Created by Alexey Boyko on 21.05.15.
//  Copyright (c) 2015 Alexey Boyko. All rights reserved.
//

#import "APIClient.h"

NSString* const APIURL = @"http://api.content.mts.intech-global.com/public/marketplaces/10/tags/12/melodies";

@interface APIClient ()

@property (nonatomic, weak) id<APIClientDelegate> delegate;
@property (nonatomic, strong) NSOperationQueue* queue;
@property (atomic, strong) NSArray* melodies;

@end

@implementation APIClient

- (id)initWithDelegate:(id<APIClientDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        _delegate = delegate;
        _queue = [[NSOperationQueue alloc] init];
        _queue.name = @"Request queue";
        _melodies = [[NSArray alloc] init];
        [self requestMelodiesFrom:0];
    }
    return self;
}

- (void)requestMelodiesFrom:(NSInteger)from
{
    NSLog(@"requesting melodies from %ld", (unsigned long)from);
    const NSInteger limit = 20;
    
    NSString* requestString = [NSString stringWithFormat:@"%@?limit=%ld&from=%ld", APIURL, (long)limit, (long)from];
    
    NSURL* url = [NSURL URLWithString:requestString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
#warning todo: process connection error
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:_queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSLog(@"received data length %lu", (unsigned long)data.length);
                               NSError* error = nil;
                               NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                               NSArray* melodies = [json objectForKey:@"melodies"];
                               _melodies = [_melodies arrayByAddingObjectsFromArray:melodies];
                               NSLog(@"_melodies count %ld", (unsigned long)_melodies.count);
                               [self performSelectorOnMainThread:@selector(notifyDelegateOnNewMelodies) withObject:nil waitUntilDone:NO];
                           }];
}

- (void)notifyDelegateOnNewMelodies
{
    [_delegate onReceiveNewMelodies];
}

- (NSInteger)melodiesCount
{
    return _melodies.count;
}

- (NSDictionary*)melodyForIndex:(NSInteger)index
{
    return [_melodies objectAtIndex:index];
}

@end
