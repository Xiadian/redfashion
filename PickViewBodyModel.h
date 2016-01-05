//
//  PickViewBodyModel.h
//  redfashion
//
//  Created by XiaDian on 16/1/4.
//  Copyright © 2016年 xue. All rights reserved.
//url

#import "BaseModel.h"

@interface PickViewBodyModel : BaseModel
@property(nonatomic,strong)NSString *cover_image_url;
@property(nonatomic,strong)NSString *content_url;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *next_url;
@end
