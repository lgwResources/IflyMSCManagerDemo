//
//  RBVoiceRecodeAnimationView.m
//  RepairBang
//
//  Created by 刘功武 on 2019/4/10.
//  Copyright © 2019年 卓众. All rights reserved.
//

#import "RBVoiceRecodeAnimationView.h"

@interface RBVoiceRecodeAnimationView ()
@property (nonatomic, strong) UIImageView *imgContent;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@end

@implementation RBVoiceRecodeAnimationView

- (void)updateWithPower:(int)power {
    if (_imgContent == nil) {
        self.imgContent = [UIImageView new];
        _imgContent.backgroundColor = [UIColor clearColor];
        _imgContent.image = [UIImage imageNamed:@"ic_record_ripple"];
        [self addSubview:_imgContent];
    }
    _imgContent.frame = CGRectMake(0, 0, _originSize.width, _originSize.height);
    int viewCount = power;
    if (viewCount == 0) {
        viewCount++;
    }
    if (viewCount > 9) {
        viewCount = 9;
    }
    
    if (_maskLayer == nil) {
        self.maskLayer = [CAShapeLayer new];
        _maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    }
    
    CGFloat itemHeight = 3;
    CGFloat itemPadding = 3.5;
    CGFloat maskPadding = itemHeight*viewCount + (viewCount-1)*itemPadding;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, _originSize.height - maskPadding, _originSize.width, _originSize.height)];
    _maskLayer.path = path.CGPath;
    _imgContent.layer.mask = _maskLayer;
}

@end
