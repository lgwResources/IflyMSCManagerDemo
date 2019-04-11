//
//  RBVoiceRecordToastContentView.m
//  RepairBang
//
//  Created by 刘功武 on 2019/4/10.
//  Copyright © 2019年 卓众. All rights reserved.
//

#import "RBVoiceRecordToastContentView.h"
#import "RBVoiceRecodeAnimationView.h"
#import "UIView+frame.h"

@interface RBVoiceRecordToastContentView ()
@property (nonatomic, strong) UIImageView *imgRecord;
@property (nonatomic, strong) RBVoiceRecodeAnimationView *powerView;
@end

@implementation RBVoiceRecordToastContentView

- (UIImageView *)imgRecord {
    if (!_imgRecord) {
        _imgRecord = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_record"]];
        _imgRecord.backgroundColor = [UIColor clearColor];
        _imgRecord.frame = CGRectMake(40, 30, 40, 65);
    }
    return _imgRecord;
}

- (RBVoiceRecodeAnimationView *)powerView {
    if (!_powerView) {
        _powerView = [[RBVoiceRecodeAnimationView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgRecord.frame)+4, CGRectGetMaxY(self.imgRecord.frame)-56, 18, 56)];
        _powerView.backgroundColor = [UIColor clearColor];
    }
    return _powerView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imgRecord.frame)+5, self.width, 20)];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"00:00";
    }
    return _timeLabel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [self addSubview:self.imgRecord];
    [self addSubview:self.powerView];
    [self addSubview:self.timeLabel];
    /**默认显示一格音量*/
    self.powerView.originSize = CGSizeMake(18, 56);
    [self.powerView updateWithPower:0];
}

- (void)updateWithPower:(int)power {
    [self.powerView updateWithPower:power];
}

@end
