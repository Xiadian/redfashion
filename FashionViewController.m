

//
//  FashionViewController.m
//  redfashion
//
//  Created by XiaDian on 16/1/2.
//  Copyright © 2016年 xue. All rights reserved.
//
#import "FashionViewController.h"
#import "FashionModel.h"
#import "FashionTableViewCell.h"
@interface FashionViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSData *fashionData;
@property(nonatomic,strong)NSArray *fashionDataArr;
@property(nonatomic,strong)UIViewController *pic;
@end
@implementation FashionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"FashionTableViewCell" bundle:nil] forCellReuseIdentifier:@"xd"];
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight=150;
    // Do any additional setup after loading the view from its nib.
     [self conNet];
      _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefresh)];
}
-(void)upRefresh{
    
    [self refreshBody];
}
-(void)refreshBody{
    FashionModel *pick=self.fashionDataArr[0];
    if (![pick.next_url isEqualToString:@"http://api.chuandazhiapp.com/v2/items?generation=2&gender=2&limit=20&offset=220"]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
        session.responseSerializer=[AFHTTPResponseSerializer serializer];
        NSString *url=pick.next_url;
        [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            self.fashionData=responseObject;
            [self getModel];
            [self.tableView reloadData];
            [_tableView.footer endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        }];
    }
    else{
        [_tableView.footer endRefreshing];
    }
}

-(void)conNet{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    //self.activityView.hidden=NO;
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    session.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *url=[NSString stringWithFormat:Fashion_url,(arc4random()%5)*20];
    [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        self.fashionData=responseObject;
        [self getModel];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      //  self.activityView.hidden=YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    }];
}
-(void)getModel{
    if(self.fashionData){
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:self.fashionData options:0 error:nil];
        NSArray *arr=dic[@"data"][@"items"];
        NSMutableArray *mArr=[[NSMutableArray alloc]initWithArray:self.fashionDataArr];
        for (NSDictionary *dicValue in arr) {
            FashionModel *pick=[[FashionModel alloc]init];
            pick.descriptions=dicValue[@"data"][@"description"];
            [pick setValuesForKeysWithDictionary:dicValue[@"data"]];
              pick.next_url=dic[@"data"][@"paging"][@"next_url"];
            [mArr addObject:pick];
        }
        self.fashionDataArr=mArr;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FashionTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"xd" forIndexPath:indexPath];
    FashionModel *model=self.fashionDataArr[indexPath.row];
    cell.descriptionTxt.text=model.descriptions;
    cell.nameTxt.text=model.name;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0,130*model.image_urls.count, 100)];
    for (int i=0; i<model.image_urls.count; i++) {
        UIImageView *imag1=[[UIImageView alloc]initWithFrame:CGRectMake(130*i,0,130,100)];
        imag1.backgroundColor=[UIColor whiteColor];
        imag1.contentMode=UIViewContentModeScaleAspectFit;
       NSString *url=model.image_urls[i];
        [imag1 sd_setImageWithURL:[NSURL URLWithString:url]placeholderImage:[UIImage imageNamed:@"zairuM"]];
        UITapGestureRecognizer *tapBg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
        imag1.userInteractionEnabled=YES;
        [imag1 addGestureRecognizer:tapBg];
        [view addSubview:imag1];
    }
     [cell.scrollView addSubview:view];
    cell.scrollView.bounces=NO;
    cell.scrollView.contentSize=view.bounds.size;
    cell.scrollView.showsHorizontalScrollIndicator=NO;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.fashionDataArr.count;
}
-(void)tapBgView:(UITapGestureRecognizer *)tapBgRecognizer
{
    UIImageView *im=(UIImageView *)tapBgRecognizer.view;
    self.pic=[[UIViewController alloc]init];
     self.pic.view.backgroundColor=[UIColor blackColor];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*2/3.0)];
    imageView.image=im.image;
    [ self.pic.view addSubview:imageView];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled=YES;
     UITapGestureRecognizer *tapBig = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBigView:)];
    [self.pic.view addGestureRecognizer:tapBig];
    [self presentViewController: self.pic animated:YES completion:nil];
}
-(void)tapBigView:(UITapGestureRecognizer *)tapBgRecognizer
{
    [self.pic dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
