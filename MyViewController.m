

//
//  MyViewController.m
//  redfashion
//
//  Created by XiaDian on 16/1/2.
//  Copyright © 2016年 xue. All rights reserved.
//

#import "MyViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface MyViewController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *button;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.button.layer.cornerRadius=40;
    self.button.clipsToBounds=YES;
}


@end
