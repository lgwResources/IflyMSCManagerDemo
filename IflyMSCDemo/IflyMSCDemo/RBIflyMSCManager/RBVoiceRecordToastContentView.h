//
//  RBVoiceRecordToastContentView.h
//  RepairBang
//
//  Created by 刘功武 on 2019/4/10.
//  Copyright © 2019年 卓众. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBVoiceRecordToastContentView : UIView
- (void)updateWithPower:(int)power;
@property (nonatomic, strong) UILabel *timeLabel;
@end
