//
//  UIView+frame.h
//  RepairBang
//
//  Created by 刘功武 on 2018/6/5.
//  Copyright © 2018年 RB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (frame)

@property(nonatomic,assign)CGFloat  x;
@property(nonatomic,assign)CGFloat  y;
@property(nonatomic,assign)CGFloat  width;
@property(nonatomic,assign)CGFloat  height;
@property(nonatomic,assign)CGPoint  origin;
@property(nonatomic,assign)CGSize   size;

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;

@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;

@end
