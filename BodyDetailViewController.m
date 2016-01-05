

//
//  BodyDetailViewController.m
//  redfashion
//
//  Created by XiaDian on 16/1/4.
//  Copyright © 2016年 xue. All rights reserved.
//

#import "BodyDetailViewController.h"

@interface BodyDetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagHeighConstraint;
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
    [self.image sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
    NSURLRequest *requst=[NSURLRequest requestWithURL:[NSURL URLWithString:self.weburl]];
       [self.webView loadRequest:requst];
    self.webView.scrollView.delegate=self;
    self.webView.delegate=self;
    self.titlelabel.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
    self.titlelabel.text=self.titles;
    self.webView.scrollView.showsVerticalScrollIndicator=NO;
   
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
 self.topConstaint.constant-=scrollView.contentOffset.y;
            if (self.topConstaint.constant>64) {
                self.topConstaint.constant=64;}
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.activeView.hidden=YES;
}
@end
