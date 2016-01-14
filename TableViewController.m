//
//  TableViewController.m
//  redfashion
//
//  Created by XiaDian on 16/1/13.
//  Copyright © 2016年 xue. All rights reserved.
//

#import "TableViewController.h"
#import <BaiduMapAPI_Base/BMKTypes.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "MJRefresh.h"
#import "DetailViewController.h"
@interface TableViewController ()<BMKMapViewDelegate,BMKPoiSearchDelegate,BMKLocationServiceDelegate>
{//搜索的指针
BMKPoiSearch *_searcher;
}
@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,strong)NSArray *distanceDataArr;
@property(nonatomic,assign)int pageindex;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageindex=0;
    self.navigationItem.leftBarButtonItem=[self getButton];
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher.delegate =self;
    [self getdata];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefresh)];
   
}
-(void)upRefresh{
    self.pageindex++;
    [self getdata];
}
-(void)getdata{
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    ///分页索引，可选，默认为0
    option.pageIndex =self.pageindex;
    //每页的数量
    option.pageCapacity = 30;
    option.sortType=BMK_POI_SORT_BY_DISTANCE;
    option.location =self.mycoor.coordinate;
    ;
    NSLog(@"%lu",self.searchType);
    switch (self.searchType) {
        case 0:{
            option.keyword = @"购物";
        
        }
            break;
        case 1:
            option.keyword = @"美食";
            
            break;
        case 2:
            option.keyword = @"景点";
            
            break;

        default:
            break;
    }
    BOOL flag = [_searcher poiSearchNearBy:option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}
//发送搜索请求回调
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    [self.tableView.footer endRefreshing];
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        //获得兴趣点的数组
        NSMutableArray *dd=[[NSMutableArray alloc]initWithArray:self.dataArr];
        [dd addObjectsFromArray:poiResultList.poiInfoList];
        self.dataArr=dd;
        [self.tableView reloadData];
       // NSLog(@"%lu",(unsigned long)arr.count);
        //获得每个兴趣点
        NSMutableArray *arr=[[NSMutableArray alloc]initWithArray:self.distanceDataArr];
        for ( BMKPoiInfo *info
             in self.dataArr) {
           
            BMKMapPoint point1 = BMKMapPointForCoordinate(self.mycoor.coordinate);
            BMKMapPoint point2 = BMKMapPointForCoordinate(info.pt);
            CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
            NSNumber *num=[[NSNumber alloc]initWithDouble:distance];
            [arr addObject:num];
        }
        self.distanceDataArr=arr;
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        // 当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        //  result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
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
-(void)doBack:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xd"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"xd"];
    }
    BMKPoiInfo *bmk=self.dataArr[indexPath.row];
    cell.textLabel.text=bmk.name;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"距离%.0f米",[self.distanceDataArr[indexPath.row] floatValue]];
    return cell;
}
-(void)viewWillDisappear:(BOOL)animated{
    _searcher.delegate =nil;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *detail=[DetailViewController new];
    BMKPoiInfo *bmk=self.dataArr[indexPath.row];
    detail.uid=bmk.uid;
    [self.navigationController pushViewController:detail animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
