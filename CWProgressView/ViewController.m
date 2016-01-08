//
//  ViewController.m
//  CWProgressView
//
//  Created by 陆尘风 on 16/1/8.
//  Copyright © 2016年 陆尘风. All rights reserved.
//

#import "ViewController.h"
#import "CWProgressView.h"

@interface ViewController ()
{
    CWProgressView *_progress1;
    CWProgressView *_progress2;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _progress1 = [[CWProgressView alloc] initWithFrame:CGRectMake(10, 80, self.view.bounds.size.width-20, 20)];
    _progress1.type = NZProgressTypeDefault;
    _progress1.isAnimation = YES;
    _progress1.progress = 0.9876;
    _progress1.progressColor = [UIColor purpleColor];
    _progress1.isRect = YES;
    [self.view addSubview:_progress1];
    
    _progress2 = [[CWProgressView alloc] initWithFrame:CGRectMake(10, 120, 100, 100)];
    _progress2.type = NZProgressTypeRing;
    _progress2.isAnimation = YES;
    _progress2.progress = 0.9876;
    _progress2.progressColor = [UIColor purpleColor];
    [self.view addSubview:_progress2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
