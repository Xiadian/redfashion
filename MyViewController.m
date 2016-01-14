

//
//  MyViewController.m
//  redfashion
//
//  Created by XiaDian on 16/1/2.
//  Copyright © 2016年 xue. All rights reserved.
//

#import "MyViewController.h"
#import "TableViewController.h"
@interface MyViewController ()<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate,BMKPoiSearchDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>{  //地图的指针
       //定位的指针
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_searchercity;
}
@property(nonatomic,strong)NSMutableArray *arrPoi;
@property(nonatomic,retain)CLLocation * mycoor;
@property(nonatomic,retain)CLLocation * endcoor;
@property(nonatomic,retain)UILabel * la;
@property (weak, nonatomic) IBOutlet UITableView *tabeleView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.button.layer.cornerRadius=50;
    self.button.clipsToBounds=YES;
    [self getback];
  
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate=self;
    [_locService startUserLocationService];
}

-(void)getback{
    self.la=[UILabel new];
    _la.frame=CGRectMake(0, 0, 100, 50);
    _la.text=@"妳的位置";
    _la.textColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:_la];
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{   self.mycoor=userLocation.location;
    [_locService stopUserLocationService];
    [self getcity];
}
-(void)getcity{
      _searchercity =[[BMKGeoCodeSearch alloc]init];
    _searchercity.delegate=self;
   // 发起反向地理编码检索
    CLLocationCoordinate2D pt = self.mycoor.coordinate;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
    BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag =[_searchercity reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
      NSLog(@"反geo检索发送成功");
    }
    else
    {
      NSLog(@"反geo检索发送失败");
    }
}
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      //在此处理正常结果
      NSArray *arr=result.poiList;
      BMKPoiInfo *bm=arr[0];
      self.la.text=bm.city;
  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TableViewController *ta=[[TableViewController alloc]init];
    ta.searchType=indexPath.section;
    ta.mycoor=self.mycoor;
    [self.navigationController pushViewController: ta animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{ //*当mapview即将被显式的时候调用，恢复之前存储的mapview状态。
}
-(void)viewWillDisappear:(BOOL)animated
{
    _locService.delegate = nil;
     _searchercity.delegate = nil;
}
@end
