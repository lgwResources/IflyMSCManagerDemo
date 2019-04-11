//
//  RBIflyMSCManager.h
//  RepairBang
//
//  Created by 刘功武 on 2019/4/10.
//  Copyright © 2019年 卓众. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RBIflyMSCSpeakType) {
    /**开始监听*/
    RBIflyMSCSpeakType_startListening,
    /**结束监听*/
    RBIflyMSCSpeakType_stopListening,
    /**取消本次会话监听*/
    RBIflyMSCSpeakType_cancel
};

@protocol RBIflyMSCManagerDelegate<NSObject>

/**语音转文字回调*/
- (void)managerSpeechResultChanged:(NSString *)result;

@optional
/**开始录音回调*/
- (void)managerOnBeginOfSpeech;
/**停止录音回调*/
- (void)managerOnEndOfSpeech;
/**音量回调*/
- (void)managerOnVolumeChanged:(int)volume;

@end

@interface RBIflyMSCManager : NSObject

@property (nonatomic, weak) id<RBIflyMSCManagerDelegate> delegate;

+ (instancetype)sharedManager;

/**初始化讯飞*/
- (void)configIflyMSC;
/**开启监听*/
- (void)startIflyMSCListening:(RBIflyMSCSpeakType)speakType;

@end
