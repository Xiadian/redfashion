//
//  FashionTableViewCell.h
//  redfashion
//
//  Created by XiaDian on 16/1/5.
//  Copyright © 2016年 xue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FashionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTxt;
@property (weak, nonatomic) IBOutlet UILabel *nameTxt;

@end
