//
//  main.m
//  Runtime
//
//  Created by twksky on 15/11/6.
//  Copyright © 2015年 twksky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        id p = [Person new];
        p.age = 1;
        [p setAge:2];
        
    }
    return 0;
}
