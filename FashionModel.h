//
//  FashionModel.h
//  redfashion
//
//  Created by XiaDian on 16/1/5.
//  Copyright © 2016年 xue. All rights reserved.
//

#import "BaseModel.h"

@interface FashionModel : BaseModel
@property(nonatomic,copy)NSString *cover_image_url;
@property(nonatomic,copy)NSString *descriptions;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,strong)NSArray *image_urls;
@end
