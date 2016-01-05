//
//  ClassModel.h
//  redfashion
//
//  Created by XiaDian on 16/1/5.
//  Copyright © 2016年 xue. All rights reserved.
//

#import "BaseModel.h"
#import "FashionModel.h"
@interface ClassModel : BaseModel
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)BOOL close;
@property(nonatomic,copy)NSArray<FashionModel *> *rowModel;
@end
