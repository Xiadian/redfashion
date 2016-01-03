//
//  PickViewController.m
//  redfashion
//
//  Created by XiaDian on 16/1/2.
//  Copyright © 2016年 xue. All rights reserved.
//

#import "PickViewController.h"

@interface PickViewController ()
@property(nonatomic,strong)NSArray *headDataArr;
@end
@implementation PickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getHeadPicModel];
    
}
-(void)getHeadPicModel{
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:self.headData options:0 error:nil];
    NSLog(@"%@",dic);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
