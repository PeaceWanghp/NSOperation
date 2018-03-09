//
//  ViewController.m
//  NSOperation
//
//  Created by peace on 2018/3/9.
//  Copyright © 2018 peace. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addButton];
    [self addOperation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark -- Operation
- (void)addOperation {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    operationQueue.maxConcurrentOperationCount = 2;//设置最大并发数
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(action) object:nil];
    [operationQueue addOperation:operation];
    
    [operationQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"222222222");
        sleep(5);
        NSLog(@"222222222");
    }]];
    
    [operationQueue addOperationWithBlock:^() {
        NSLog(@"333333333");
        NSLog(@"执行一个新的操作，线程：%@", [NSThread currentThread]);
        sleep(5);
        NSLog(@"33333333");
    }];
    
    //    [operationQueue cancelAllOperations];//取消所有Operations

}

- (void)action {
    NSLog(@"11111111");
    sleep(5);
    NSLog(@"11111111");
}

#pragma mark -
#pragma mark -- UI
- (void)addButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor cyanColor]];
    [button setFrame:CGRectMake(0, 0, 100, 44)];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonAction {
    NSLog(@"touch button...............");
}

@end
