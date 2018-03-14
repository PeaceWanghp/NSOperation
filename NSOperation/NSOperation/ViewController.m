//
//  ViewController.m
//  NSOperation
//
//  Created by peace on 2018/3/9.
//  Copyright © 2018 peace. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSOperationQueue *_operationQueue;
    
    NSInteger _count;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 5;//设置最大并发数
    }
    
    float baseY = 20;
    float spaceHeight = 60;
    
    [self addOperationButton:baseY];
    [self addDependencyOperationButton:baseY+spaceHeight];
    [self baseOperationButton:baseY+spaceHeight*2];
    [self cancelAllButton:baseY+spaceHeight*3];
    [self cancelButton:baseY+spaceHeight*4];
    [self waitOperationButton:baseY+spaceHeight*5];
    [self waitQueueButton:baseY+spaceHeight*6];
    [self pauseButton:baseY+spaceHeight*7];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark -- Operation
- (void)action:(NSString *)key {
    NSLog(@"Begin %@",key);
    sleep(3);
    _count ++;
    NSLog(@"End %@",key);
}

#pragma mark -
#pragma mark -- Action
- (void)addBaseOperationAction {
    NSLog(@"---------------- Add Base Operation Action");
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(action:) object:@"1111111"];
    [_operationQueue addOperation:operation];
    
    [_operationQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        [self action:@"222222222"];
    }]];
    
    [_operationQueue addOperationWithBlock:^() {
        [self action:@"33333333333"];
    }];
}

- (void)addOperationAction {
    NSLog(@"--------------- Add Operation Action");
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [self action:@"4444444444"];
    }];
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [self action:@"5555555555"];
    }];
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [self action:@"66666666666"];
    }];
    [_operationQueue addOperation:operation1];
    [_operationQueue addOperation:operation2];
    [_operationQueue addOperation:operation3];
}

- (void)addDependencyOperationAction {
    NSLog(@"------------------Add Dependency Operation Action");
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [self action:@"77777777777"];
    }];
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [self action:@"888888888888"];
    }];
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [self action:@"99999999999"];
    }];
    
    [operation1 addDependency:operation2];
    [operation2 addDependency:operation3];
    
    [_operationQueue addOperation:operation1];
    [_operationQueue addOperation:operation2];
    [_operationQueue addOperation:operation3];
}

- (void)waitUntilFinishedAction {
    NSLog(@"------------ Wait Until Finished");
    __block int number = 0;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [self action:@"aaaaaaaaaaa"];
        number ++;
    }];
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"Begain Wait");
        [operation waitUntilFinished];
        NSLog(@"End Wait");
        if (number > 0) {
            NSLog(@"Good Job!");
        }
    }];
    
    [_operationQueue addOperation:operation1];
    [_operationQueue addOperation:operation];
}

- (void)waitQueueUntilFinishedAction {
    NSLog(@"------------ Wait Queue Until Finished Action");
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    [queue addOperationWithBlock:^() {
        [_operationQueue waitUntilAllOperationsAreFinished];
        NSLog(@"Result : %d",(int)_count);
    }];
}

- (void)cancelAllAction {
    NSLog(@"pauzeButtonAction...............");
    [_operationQueue cancelAllOperations];
}

- (void)cancelAction {
    NSLog(@"pauzeButtonAction...............");
    for (NSOperation *operation in _operationQueue.operations) {
        [operation cancel];
    }
}

- (void)pauseAction {
    if (!_operationQueue.suspended) {
        NSLog(@"pause Action...............");
    }
    else {
        NSLog(@"continue Action...............");
    }
    
    [_operationQueue setSuspended:!_operationQueue.suspended];
}

#pragma mark -
#pragma mark -- UI
- (void)addOperationButton:(float)y {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor cyanColor]];
    [button setFrame:CGRectMake(0, y, self.view.frame.size.width, 44)];
    [button setTitle:@"Add Operation" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addOperationAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)addDependencyOperationButton:(float)y {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor cyanColor]];
    [button setFrame:CGRectMake(0, y, self.view.frame.size.width, 44)];
    [button setTitle:@"Add Dependency Operation" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addDependencyOperationAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)cancelAllButton:(float)y {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor cyanColor]];
    [button setFrame:CGRectMake(0, y, self.view.frame.size.width, 44)];
    [button setTitle:@"Cancel All" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelAllAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)cancelButton:(float)y {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor cyanColor]];
    [button setFrame:CGRectMake(0, y, self.view.frame.size.width, 44)];
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)waitOperationButton:(float)y {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor cyanColor]];
    [button setFrame:CGRectMake(0, y, self.view.frame.size.width, 44)];
    [button setTitle:@"Wait Operation" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(waitUntilFinishedAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)waitQueueButton:(float)y {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor cyanColor]];
    [button setFrame:CGRectMake(0, y, self.view.frame.size.width, 44)];
    [button setTitle:@"Wait Queue" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(waitQueueUntilFinishedAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)baseOperationButton:(float)y {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor cyanColor]];
    [button setFrame:CGRectMake(0, y, self.view.frame.size.width, 44)];
    [button setTitle:@"Add Base Operation" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addBaseOperationAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)pauseButton:(float)y {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor cyanColor]];
    [button setFrame:CGRectMake(0, y, self.view.frame.size.width, 44)];
    [button setTitle:@"Pause" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pauseAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

@end
