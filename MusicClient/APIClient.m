//
//  APIClient.m
//  MusicClient
//
//  Created by Alexey Boyko on 21.05.15.
//  Copyright (c) 2015 Alexey Boyko. All rights reserved.
//

#import "APIClient.h"
#import "UIAlertView+showAlert.h"

NSString* const APIURL = @"http://api.content.mts.intech-global.com/public/marketplaces/10/tags/12/melodies";

@interface APIClient ()

@property (nonatomic, weak) id<APIClientDelegate> delegate;
@property (nonatomic, strong) NSOperationQueue* queue;
@property (atomic, strong) NSArray* melodies;
@property (atomic) BOOL requestInProgress;

@end

@implementation APIClient

- (id)initWithDelegate:(id<APIClientDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.name = @"Request queue";
        self.melodies = [[NSArray alloc] init];
        self.requestInProgress = NO;
        [self requestMelodiesFrom:0];
    }
    return self;
}

- (NSInteger)melodiesCount
{
    return self.melodies.count;
}

- (NSDictionary*)melodyForIndex:(NSInteger)index
{
    if (self.melodies.count - index < 10)
        [self requestMelodiesFrom:self.melodies.count];
    return [self.melodies objectAtIndex:index];
}

- (void)requestMelodiesFrom:(NSInteger)from
{
    if (self.requestInProgress)
        return;
    self.requestInProgress = YES;
    NSLog(@"requesting melodies from %ld", (unsigned long)from);
    const NSInteger limit = 200;
    
    NSString* requestString = [NSString stringWithFormat:@"%@?limit=%ld&from=%ld", APIURL, (long)limit, (long)from];
    
    NSURL* url = [NSURL URLWithString:requestString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:self.queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError == nil)
                               {
                                   [self appendReceivedData:data from:from];
                               }
                               else
                               {
                                   NSString* errorString = [NSString stringWithFormat:@"%@", connectionError];
                                   [UIAlertView showAlert:errorString];
                               }
                               self.requestInProgress = NO;
                           }];
}

- (void)appendReceivedData:(NSData*)data from:(NSInteger)from
{
    NSLog(@"received data length %lu", (unsigned long)data.length);
    NSError* error = nil;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSArray* melodies = [json objectForKey:@"melodies"];
    self.melodies = [self.melodies arrayByAddingObjectsFromArray:melodies];
    NSLog(@"_melodies count %ld", (unsigned long)self.melodies.count);
    [self performSelectorOnMainThread:@selector(notifyDelegateOnNewMelodies) withObject:nil waitUntilDone:NO];
}

- (void)notifyDelegateOnNewMelodies
{
    [self.delegate onReceiveNewMelodies];
}

@end
