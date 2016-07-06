//
//  main.m
//  Sevice
//
//  Created by foscom on 16/7/4.
//  Copyright © 2016年 zengjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GCDServer.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        
        [[GCDServer shareGCDServerManger] acceptClient];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
