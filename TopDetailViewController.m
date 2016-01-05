//
//  TopDetailViewController.m
//  redfashion
//
//  Created by XiaDian on 16/1/4.
//  Copyright © 2016年 xue. All rights reserved.
//

#import "TopDetailViewController.h"
#import "PickViewTableViewCell.h"
#import "BodyDetailViewController.h"
#import "PickViewBodyModel.h"
@interface TopDetailViewController ()
@property(nonatomic,strong)NSData *headData;
@property(nonatomic,strong)NSArray *headDataArr;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation TopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem=[self getButton];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.title=@"专题";
    [self.tableview registerNib:[UINib nibWithNibName:@"PickViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"xd"];
    // Do any additional setup after loading the view from its nib.
     [self conNet];
}
-(void)conNet{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    //self.activityView.hidden=NO;
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    session.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *url=self.dataUrl;
    [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
      //  self.activityView.hidden=YES;
        self.headData=responseObject;
        [self getHeadModel];
        [self.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      //  self.activityView.hidden=YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    }];
}
-(void)getHeadModel{
    if(self.headData){
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:self.headData options:0 error:nil];
        NSArray *arr=dic[@"data"][@"posts"];
        NSMutableArray *mArr=[NSMutableArray new];
        for (NSDictionary *dicValue in arr) {
            PickViewBodyModel *pick=[[PickViewBodyModel alloc]init];
            [pick setValuesForKeysWithDictionary:dicValue];
            [mArr addObject:pick];
        }
        self.headDataArr=mArr;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PickViewTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"xd" forIndexPath:indexPath];
    PickViewBodyModel *pic=self.headDataArr[indexPath.row];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:pic.cover_image_url]];
    cell.titleLabel.text=pic.title;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.headDataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PickViewBodyModel *pic=self.headDataArr[indexPath.row];
    BodyDetailViewController *boView=[BodyDetailViewController new];
    boView.weburl=pic.content_url;
    boView.imageUrl=pic.cover_image_url;
    boView.titles=pic.title;
    [self.navigationController pushViewController:boView animated:YES];
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
