//
//  GCDServer.m
//  Sevice
//
//  Created by foscom on 16/7/4.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "GCDServer.h"
#define kport 8080

@implementation GCDServer
{
    GCDAsyncSocket *_socket;
    NSString *midstr;
}


+ (id)shareGCDServerManger
{
    
    static GCDServer *server = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        server = [[GCDServer alloc] init];
    });
    
    return server;
}


- (void)messages:(void (^)(NSString *))blocks
{
    _msgBlock = blocks;
}


- (void)connectStatus:(void (^)(NSInteger, NSString *))blocke
{
    _connectBlock = blocke;
    
}
- (id)init
{
    if (self = [super init]) {
        
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        
    }
    
    return self;
    
}


- (void)acceptClient
{
    [self acceptClientOnPort:kport];
}


- (void)acceptClientOnPort:(UInt16)port
{
    
    NSError *error;
    
    if ([_socket acceptOnPort:port error:&error]) {
        
        NSLog(@"监听端口成功");
//            _connectBlock(MonitorSuccess,nil);

        
        
    }else
    {
//                _connectBlock(MonitorFail,nil);
        
        NSLog(@"监听端口失败 %@",[error localizedDescription]);
    }
    
    
}



- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    NSLog(@"请求连接的设备的地址:%@",newSocket.connectedHost);
    //发送数据给 客户端
    
    _connectBlock(Gethost,newSocket.connectedHost);
    
    [newSocket writeData:[@"hello" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    
    // 接受客户端的数据
    [newSocket readDataWithTimeout:-1 tag:100];
    
}



- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"发送成功");
    
}


- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    NSString *striData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到的数据:%@",striData);
    _msgBlock(striData);
    
    _connectBlock(Getdata,striData);

    [sock readDataWithTimeout:-1 tag:0]; // 继续接收数据
    
}

@end












