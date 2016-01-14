//
//  DetailViewController.m
//  redfashion
//
//  Created by XiaDian on 16/1/14.
//  Copyright © 2016年 xue. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<BMKPoiSearchDelegate,UIWebViewDelegate>
{
    BMKPoiSearch *_searcher;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
@implementation DetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem=[self getButton];
    _searcher =[[BMKPoiSearch alloc]init];
     [self getdata];
}
-(void)getdata{
    //POI详情检索
    BMKPoiDetailSearchOption* option = [[BMKPoiDetailSearchOption alloc] init];
    option.poiUid =self.uid;//POI搜索结果中获取的uid
    BOOL flag = [_searcher poiDetailSearch:option];
    if(flag)
    {
      //  NSLog(@"//详情检索发起成功");
    }
    else
    {
        //详情检索发送失败
    }
}
-(void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode
{
    if(errorCode == BMK_SEARCH_NO_ERROR){
        // 在此处理正常结果
        NSURL *url=[NSURL URLWithString:poiDetailResult.detailUrl];
        NSLog(@"%@",poiDetailResult.detailUrl);
        if ([poiDetailResult.detailUrl isEqualToString:@"http://map.baidu.com/"]) {
            [self.view.window showHUDWithText:@"抱歉！未找到详情！！" Type:ShowPhotoNo Enabled:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSURLRequest *re=[NSURLRequest requestWithURL:url];
            [self.webView loadRequest:re];
        }
        self.webView.delegate=self;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{ //*当mapview即将被显式的时候调用，恢复之前存储的mapview状态。
    
    _searcher.delegate=self;
}
-(void)viewWillDisappear:(BOOL)animated
{
      _searcher.delegate = nil;
   
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
