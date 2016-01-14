//
//  PickViewController.m
//  redfashion
//
//  Created by XiaDian on 16/1/2.
//  Copyright © 2016年 xue. All rights reserved.
//

#import "PickViewController.h"
#import "PickViewHeadModel.h"
#import "PickViewTableViewCell.h"
#import "PickViewBodyModel.h"
#import "BodyDetailViewController.h"
#import "TopDetailViewController.h"
@interface PickViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSData *headData;
@property(nonatomic,strong)UIScrollView *scro;
@property(nonatomic,strong)NSArray *headDataArr;
@property(nonatomic,strong)NSData *bodyData;
@property(nonatomic,assign)NSInteger page;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property(nonatomic,strong)NSArray *infoDataArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
@implementation PickViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page=arc4random()%15;
    [self.tableView registerNib:[UINib nibWithNibName:@"PickViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"xd"];
    // Do any additional setup after loading the view from its nib.
    [self checkNet];
    self.tableView.header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHead)];
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefresh)];
    [self createUI];
}
-(void)refreshHead{
 [self conNet];
}
-(void)upRefresh{
    [self refreshBody];
}
-(void)refreshBody{
    PickViewBodyModel * body=self.infoDataArr[0];
    if (![body.next_url isEqualToString:@"http://api.chuandazhiapp.com/v1/channels/20/items?generation=2&gender=2&limit=20&offset=20"]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    self.activityView.hidden=NO;
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    session.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *urlbody=body.next_url;
    [session GET:urlbody parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        self.activityView.hidden=YES;
        self.bodyData=responseObject;
        [self getBodyPicModel];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.activityView.hidden=YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [self.tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];
    }
    else{
        [_tableView.footer endRefreshing];
    }
}
-(void)createUI{
    self.scro=[UIScrollView new];
    self.scro.frame=CGRectMake(0,0,SCREEN_WIDTH,150);
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH*self.headDataArr.count, 150)];
    [self.scro addSubview:view];
    for (int i=0; i<self.headDataArr.count; i++) {
        UIImageView *imag1=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i,0, SCREEN_WIDTH,150)];
        UIPageControl *page=[[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, 130, 60, 20)];
        page.numberOfPages=self.headDataArr.count;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
        imag1.userInteractionEnabled=YES;
        [imag1 addGestureRecognizer:tap];
        page.currentPage=i;
        [imag1 addSubview:page];
        imag1.backgroundColor=[UIColor lightGrayColor];
        PickViewHeadModel *pick=self.headDataArr[i];
        imag1.tag=[pick.id integerValue];
        [imag1 sd_setImageWithURL:[NSURL URLWithString:pick.image_url]];
        [view addSubview:imag1];
    }
    self.scro.showsHorizontalScrollIndicator=NO;
    self.scro.showsVerticalScrollIndicator=NO;
    self.scro.pagingEnabled=YES;
    self.scro.bounces=NO;
    self.scro.contentOffset=CGPointMake(0,0);
    self.scro.contentSize=view.bounds.size;
    self.tableView.tableHeaderView=self.scro;
}
-(void)tapImage:(UITapGestureRecognizer *)tap{
    NSString *ss=[NSString stringWithFormat:Zhuanti_url,tap.view.tag];
    TopDetailViewController *topD=[TopDetailViewController new];
    topD.dataUrl=ss;
    [self.navigationController pushViewController:topD animated:YES];
}
-(void)conNet{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    self.activityView.hidden=NO;
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    session.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *url=PickView_head;
   [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        self.activityView.hidden=YES;
        self.headData=responseObject;
        [self getHeadPicModel];
         [self createUI];
        [self.tableView.header endRefreshing];
        [_tableView.footer endRefreshing];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.activityView.hidden=YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [self.tableView.header endRefreshing];
        [_tableView.footer endRefreshing];

    }];
     NSString *urlbody=[NSString stringWithFormat:PickView_body,self.page];
    [session GET:urlbody parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        self.activityView.hidden=YES;
        self.bodyData=responseObject;
        [self getBodyPicModel];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.activityView.hidden=YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [self.tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];
}

-(void)getHeadPicModel{
if(self.headData){
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:self.headData options:0 error:nil];
    NSArray *arr=dic[@"data"][@"banners"];
    NSMutableArray *mArr=[[NSMutableArray alloc]init];
    for (NSDictionary *dicValue in arr) {
        PickViewHeadModel *pick=[[PickViewHeadModel alloc]init];
        pick.image_url=dicValue[@"image_url"];
        [pick setValuesForKeysWithDictionary:dicValue[@"target"]];
        [mArr addObject:pick];
    }
    self.headDataArr=mArr;
}
}
- (void) checkNet{
    //开启网络状态监控
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if(status==AFNetworkReachabilityStatusReachableViaWiFi){
            NSLog(@"当前是wifi");
            [self conNet];
        }
        if(status==AFNetworkReachabilityStatusReachableViaWWAN){
            NSLog(@"当前是3G");
            [self conNet];

        }
        if(status==AFNetworkReachabilityStatusNotReachable){
            NSLog(@"当前是没有网络");
            
        }
        if(status==AFNetworkReachabilityStatusUnknown){
            NSLog(@"当前是未知网络");
        }
    }];
}
-(void)getBodyPicModel{
    if(self.bodyData){
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:self.bodyData options:0 error:nil];
        NSArray *arr=dic[@"data"][@"items"];
        NSString *ss=dic[@"data"][@"paging"][@"next_url"];
        NSMutableArray *mArr=[[NSMutableArray alloc]initWithArray:self.infoDataArr];
        for (NSDictionary *dicValue in arr) {
            PickViewBodyModel *pick=[[PickViewBodyModel alloc]init];
            pick.next_url=ss;
            [pick setValuesForKeysWithDictionary:dicValue];
            [mArr addObject:pick];
        }
        self.infoDataArr=mArr;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PickViewTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"xd" forIndexPath:indexPath];
    PickViewBodyModel *pic=self.infoDataArr[indexPath.row];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:pic.cover_image_url]placeholderImage:[UIImage imageNamed:@"zairu"]];
    cell.titleLabel.text=pic.title;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return  self.infoDataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PickViewBodyModel *pic=self.infoDataArr[indexPath.row];
    BodyDetailViewController *boView=[BodyDetailViewController new];
    boView.weburl=pic.content_url;
    boView.imageUrl=pic.cover_image_url;
    boView.titles=pic.title;
    [self.navigationController pushViewController:boView animated:YES];
}
@end
