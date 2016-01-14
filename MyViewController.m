

//
//  MyViewController.m
//  redfashion
//
//  Created by XiaDian on 16/1/2.
//  Copyright © 2016年 xue. All rights reserved.
//

#import "MyViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface MyViewController ()<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabeleView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.button.layer.cornerRadius=50;
    self.button.clipsToBounds=YES;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     UITableViewCell *aa=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xd"];
    aa.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section) {
        case 0:
            aa.textLabel.text=@"带你去逛街";
            break;
        case 1:
            aa.textLabel.text=@"带你去吃饭";
            break;
        case 2:
            aa.textLabel.text=@"带你去旅行";
            break;
            
        default:
            break;
    }
    return aa;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

@end
