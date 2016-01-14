//
//  TableViewController.h
//  redfashion
//
//  Created by XiaDian on 16/1/13.
//  Copyright © 2016年 xue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface TableViewController : UITableViewController<BMKMapViewDelegate>
@property(nonatomic,assign)NSInteger searchType;
@property(nonatomic,retain)CLLocation * mycoor;
@end
