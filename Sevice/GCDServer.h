//
//  GCDServer.h
//  Sevice
//
//  Created by foscom on 16/7/4.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@interface GCDServer : NSObject<GCDAsyncSocketDelegate>
+ (id)shareGCDServerManger;
- (void)acceptClient;
- (void)acceptClientOnPort:(UInt16)port;

- (void)messages:(void(^)(NSString *))blocks;

- (void)connectStatus:(void(^)(NSInteger,NSString *))blocke;

@property(nonatomic,copy)void(^msgBlock)(NSString *msg);
@property(nonatomic,copy)void(^connectBlock)(NSInteger status,NSString *str);

@end
