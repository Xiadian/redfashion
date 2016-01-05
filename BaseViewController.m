//
//  BaseViewController.m
//  redfashion
//
//  Created by XiaDian on 16/1/2.
//  Copyright © 2016年 xue. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()
@end
@implementation BaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view=[[UIView alloc]initWithFrame:[[UIApplication sharedApplication]statusBarFrame]];
    view.backgroundColor=[UIColor colorWithRed:253/255.0 green:124/255.0 blue:156/255.0 alpha:1];
    [self.view addSubview:view];
    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIBarButtonItem *)getButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 64, 44);
    [backBtn setTitle:@"<返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-10, 0, 0);
    backBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    return backItem;
}
-(UIBarButtonItem *)getloginButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 64, 44);
    [backBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-10, 0, 0);
    backBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    return backItem;
}
-(void)login:(UIButton *)btn{
 
}
-(void)doBack:(UIButton *)btn{

    [self.navigationController popViewControllerAnimated:YES];

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
