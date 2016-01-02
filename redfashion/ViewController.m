//
//  ViewController.m
//  redfashion
//
//  Created by XiaDian on 15/12/31.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "ViewController.h"
#import "RootTabBarController.h"
//屏幕宽高
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()
@property(nonatomic,strong)UIScrollView *scro;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏title颜色w
    NSDictionary * textA = @{
                             NSFontAttributeName : [UIFont systemFontOfSize:18],
                             NSForegroundColorAttributeName : [UIColor whiteColor],
                             };
    [[UINavigationBar appearance] setTitleTextAttributes:textA];
    // 设置所有导航背景颜色
  [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:253/255.0 green:124/255.0 blue:156/255.0 alpha:1]];
   // Do any additional setup after loading the view, typically from a nib.
   if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
       [self creatFirstStartScrollView];}
   else{
       UIImageView *im=[[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
       im.image=[UIImage imageNamed:@"s_0"];
       [self.view addSubview:im];
       [self performSelector:@selector(takein:) withObject:nil afterDelay:2];
   }
}
//第一次启动滑动导航
-(void)creatFirstStartScrollView{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
    CGRect frame=[[UIScreen mainScreen] bounds];
    self.scro=[[UIScrollView alloc]initWithFrame:frame];
    self.scro.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:self.scro];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*4, SCREEN_HEIGHT)];
    [self.scro addSubview:view];
    for (int i=0; i<4; i++) {
        UIImageView *imag1=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imag1.image=[UIImage imageNamed:[NSString stringWithFormat:@"s_%d",i]];
            [view addSubview:imag1];
        UIPageControl *page=[[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, SCREEN_HEIGHT-30, 60, 20)];
        page.numberOfPages=4;
        page.currentPage=i;
        [imag1 addSubview:page];
         if(i==3){
             imag1.userInteractionEnabled=YES;
             UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3.0, SCREEN_HEIGHT-50, SCREEN_WIDTH/3.0, 50)];
             btn.titleLabel.font=[UIFont systemFontOfSize:18];
             [btn setTitle:@"点击进入" forState:UIControlStateNormal];
             [btn addTarget:self action:@selector(takein:) forControlEvents:UIControlEventTouchUpInside];
             page.hidden=YES;
             [imag1 addSubview:btn];
        }
    }
    self.scro.bounces=NO;
    
    self.scro.contentOffset=CGPointMake(0, 0);
    self.scro.contentSize=view.bounds.size;
    self.scro.pagingEnabled=YES;
}
-(void)takein:(UIButton *)btn{
    //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //由storyboard根据myView的storyBoardID来获取我们要切换的视图
    CATransition *ca=[[CATransition alloc]init];
    ca.type=@"rippleEffect";
    ca.duration=1;
    [self.view.window.layer addAnimation:ca forKey:nil];
    RootTabBarController *root = [story instantiateViewControllerWithIdentifier:@"RootTabBarController"];
    [self presentViewController:root animated:YES completion:nil];
}
@end
