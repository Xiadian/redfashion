

//
//  ClassificationViewController.m
//  redfashion
//
//  Created by XiaDian on 16/1/2.
//  Copyright © 2016年 xue. All rights reserved.
//

#import "ClassificationViewController.h"
#import "PickViewTableViewCell.h"
#import "PickViewBodyModel.h"
#import "ClassModel.h"
#import "FashionModel.h"
#import "ClassCollectionViewCell.h"
#import "BodyDetailViewController.h"
@interface ClassificationViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSData *ClassTableData;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property(nonatomic,strong)NSArray *ClassTableDataArr;
@property(nonatomic,strong)NSData *ClassCollectionData;
@property(nonatomic,strong)NSArray *ClassCollectionDataArr;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ClassificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor=[[UIColor colorWithRed:253/255.0 green:124/255.0 blue:156/255.0 alpha:1]colorWithAlphaComponent:0.6];
    // Do any additional setup after loading the view from its nib.
    [self.collectionView registerNib:[UINib nibWithNibName:@"ClassCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"xdc"];
    [self conNet];
self.collectionView.backgroundColor=[[UIColor colorWithRed:253/255.0 green:124/255.0 blue:156/255.0 alpha:1]colorWithAlphaComponent:0.3];
}
-(void)conNet{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
   self.activityView.hidden=NO;
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    session.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *url=Class_group_url;
    [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        self.activityView.hidden=YES;
        self.ClassTableData=responseObject;
        [self getModel];
        [self.tableView reloadData];
      //  [self createUI];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      //  self.activityView.hidden=YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    }];
    session.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *urlll=[NSString stringWithFormat:Class_collec_url,@"1"];
    [session GET:urlll parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        self.activityView.hidden=YES;
        self.ClassCollectionData=responseObject;
        [self getcollectModel];
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          self.activityView.hidden=YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    }];
    
}
-(void)getModel{
    if(self.ClassTableData){
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:self.ClassTableData options:0 error:nil];
        NSArray *arr=dic[@"data"][@"channel_groups"];
       // NSLog(@"%@",arr);
        NSMutableArray *DataArr=[NSMutableArray new];
        for (NSDictionary *dicValue in arr) {
            ClassModel *class=[ClassModel new];
            class.name=dicValue[@"name"];
            class.close=YES;
             NSMutableArray *mArr=[NSMutableArray new];
            for (NSDictionary *dic in dicValue[@"channels"]) {
               // NSLog(@"%@",dic);
                 FashionModel *pick=[[FashionModel alloc]init];
                [pick setValuesForKeysWithDictionary:dic];
                [mArr addObject:pick];
            }
            class.rowModel=mArr;
            [DataArr addObject:class];
       }
        self.ClassTableDataArr=DataArr;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"xd"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xd"];
        cell.contentView.backgroundColor=[[UIColor colorWithRed:253/255.0 green:124/255.0 blue:156/255.0 alpha:1]colorWithAlphaComponent:0.8];
    }
    ClassModel *pic=self.ClassTableDataArr[indexPath.section];
    FashionModel *ff=pic.rowModel[indexPath.row];
    cell.textLabel.text=ff.name;
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    cell.textLabel.textColor=[UIColor whiteColor];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ClassModel *c=self.ClassTableDataArr[section];
    if (c.close) {
        return 0;
    }
    return c.rowModel.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.ClassTableDataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ClassModel *pic=self.ClassTableDataArr[section];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 100, 80);
    btn.tag = section + 100;
    [btn setTitle:pic.name forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:253/255.0 green:124/255.0 blue:156/255.0 alpha:1];
    [btn addTarget:self action:@selector(headerClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    return btn;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}
- (void)headerClick:(UIButton *)sender {
    ClassModel *sm =self.ClassTableDataArr[sender.tag - 100];
    sm.close = !sm.close;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag - 100] withRowAnimation:0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
     self.activityView.hidden=NO;
    ClassModel *sm =self.ClassTableDataArr[indexPath.section];
    FashionModel *fs=sm.rowModel[indexPath.row];
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    session.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *url=[NSString stringWithFormat:Class_collec_url,fs.id];
    [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        self.activityView.hidden=YES;
        self.ClassCollectionData=responseObject;
        [self getcollectModel];
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          self.activityView.hidden=YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    }];
}
-(void)getcollectModel{
    if(self.ClassCollectionData){
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:self.ClassCollectionData options:0 error:nil];
        NSArray *arr=dic[@"data"][@"items"];
        NSMutableArray *DataArr=[NSMutableArray new];
        for (NSDictionary *dicValue in arr) {
            PickViewBodyModel *pc=[PickViewBodyModel new];
            [pc setValuesForKeysWithDictionary:dicValue];
            [DataArr addObject:pc];
        }
        self.ClassCollectionDataArr=DataArr;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.ClassCollectionDataArr.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width =[UIScreen mainScreen].bounds.size.width-105;
    return CGSizeMake(width,80);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10,2, 10,2);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"xdc" forIndexPath:indexPath];
       PickViewBodyModel  *hm = self.ClassCollectionDataArr[indexPath.row];
    [cell.imageVIew sd_setImageWithURL:[NSURL URLWithString:hm.cover_image_url]placeholderImage:[UIImage imageNamed:@"zairu"]];
    cell.labelTxt.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.6];
    cell.labelTxt.text=hm.title;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PickViewBodyModel *pic=self.ClassCollectionDataArr[indexPath.row];
    BodyDetailViewController *boView=[BodyDetailViewController new];
    boView.weburl=pic.content_url;
    boView.imageUrl=pic.cover_image_url;
    boView.titles=pic.title;
    [self.navigationController pushViewController:boView animated:YES];
}
@end
