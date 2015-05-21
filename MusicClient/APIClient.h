//
//  APIClient.h
//  MusicClient
//
//  Created by Alexey Boyko on 21.05.15.
//  Copyright (c) 2015 Alexey Boyko. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APIClientDelegate <NSObject>

- (void)onReceiveNewMelodies;

@end

@interface APIClient : NSObject

- (id)initWithDelegate:(id<APIClientDelegate>)delegate;
- (void)requestMelodiesFrom:(NSInteger)from;
- (NSInteger)melodiesCount;
- (NSDictionary*)melodyForIndex:(NSInteger)index;

@end
