//
//  ViewController.m
//  Sevice
//
//  Created by foscom on 16/7/4.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import "ViewController.h"
#import "GCDServer.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface ViewController ()
{
    UILabel *label;
}
@end

extern NSString *msg;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *hostLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 200, 30)];
     hostLabel.text = [@"本地IP 地址:" stringByAppendingString:[self getIPAddress]];
    [self.view addSubview:hostLabel];

    
    UILabel *lableAlert = [[UILabel alloc] initWithFrame:CGRectMake(30, 150, 300, 40)];
    lableAlert.backgroundColor = [UIColor lightGrayColor];
    lableAlert.textColor = [UIColor whiteColor];
    
    [self.view addSubview:lableAlert];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(30, 200, 200, 40)];
    label.backgroundColor = [UIColor lightGrayColor];
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
    
    [[GCDServer shareGCDServerManger] messages:^(NSString * str) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            label.text = str;

        });
        
    }];
    
    [[GCDServer shareGCDServerManger] connectStatus:^(NSInteger sta, NSString *str) {
        if (sta == 0) {
            
            lableAlert.text = @"监听端口成功";
        }
        if (sta == 1) {
            
            lableAlert.text = [@"请求连接的IP:" stringByAppendingString:str];
            
        }
        
        if (sta == 2) {
            
            lableAlert.text = [@"接收信息成功:" stringByAppendingString:str];
        }
       
        if(sta == 3)
        {
            lableAlert.text = @"监听端口失败";

        }
        
    }];
    
    
    
}


- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (void)msgchange:(NSNotification *)center
{
    NSDictionary *dic = center.userInfo;
    label.text = dic[@"msg"];
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
