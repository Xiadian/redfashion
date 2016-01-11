

//
//  BodyDetailViewController.m
//  redfashion
//
//  Created by XiaDian on 16/1/4.
//  Copyright © 2016年 xue. All rights reserved.
//

#import "BodyDetailViewController.h"

@interface BodyDetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activeView;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation BodyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.leftBarButtonItem=[self getButton];
    self.navigationItem.title=@"搭配详情";
    NSURLRequest *requst=[NSURLRequest requestWithURL:[NSURL URLWithString:self.weburl]];
       [self.webView loadRequest:requst];
    UIImageView *im=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 150)];
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    lab.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
    lab.text=self.titles;
    [im sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
    [self.webView.scrollView addSubview:im];
    self.webView.delegate=self;
    self.webView.scrollView.showsVerticalScrollIndicator=NO;
    self.webView.hidden=YES;
    self.webView.scrollView.bounces=NO;

}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.activeView.hidden=YES;
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].style.padding='150px 0px 0px 0px'"];
    self.webView.hidden=NO;
    
}

@end
