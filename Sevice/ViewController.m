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

    label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    label.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:label];
    
    
    [[GCDServer shareGCDServerManger] messages:^(NSString * str) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            label.text = str;

        });
        
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgchange:) name:@"message" object:nil];
    
    
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
