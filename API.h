//
//  API.h
//  redfashion
//
//  Created by XiaDian on 16/1/3.
//  Copyright © 2016年 xue. All rights reserved.
//

#ifndef API_h
#define API_h
//搭配页面首页表头文件
#define PickView_head  @"http://api.chuandazhiapp.com/v1/banners?channel=iOS"
//拼接%d到10;
#define PickView_body  @"http://api.chuandazhiapp.com/v1/channels/%ld/items?gender=2&generation=2&limit=20&offset=0"
#define Zhuanti_url @"http://api.chuandazhiapp.com/v1/collections/%ld/posts?gender=2&generation=2&limit=20&offset=0"
#define Fashion_url @"http://api.chuandazhiapp.com/v2/items?gender=2&generation=2&limit=20&offset=0"
#define Class_group_url @"http://api.chuandazhiapp.com/v1/channel_groups/all"
#define Class_collec_url @"http://api.chuandazhiapp.com/v1/channels/%@/items?limit=20&offset=0"
#endif /* API_h */
