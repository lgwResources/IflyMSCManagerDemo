//
//  RBIflyMSCManager.m
//  RepairBang
//
//  Created by 刘功武 on 2019/4/10.
//  Copyright © 2019年 卓众. All rights reserved.
//

#import "RBIflyMSCManager.h"
#import "RBObjectSingleton.h"
#import "RBVoiceRecordToastContentView.h"
#import <iflyMSC/iflyMSC.h>
#import "AppDelegate.h"
static NSString *iflyMSC_APPID = @"5ca305f0";

@interface RBIflyMSCManager ()<IFlySpeechRecognizerDelegate>
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property (nonatomic, strong) RBVoiceRecordToastContentView *speechView;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, strong) NSString *currentTimeStr;
@end

@implementation RBIflyMSCManager
RBOBJECT_SINGLETON_BOILERPLATE(RBIflyMSCManager, sharedManager)

- (IFlySpeechRecognizer *)iFlySpeechRecognizer {
    if (!_iFlySpeechRecognizer) {
        /**创建语音识别对象*/
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        /**设置为听写模式*/
        [_iFlySpeechRecognizer setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
        /**asr_audio_path 是录音文件名，设置value为nil或者为空取消保存，默认保存目录在Library/cache下。*/
        [_iFlySpeechRecognizer setParameter:@"iat.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        /**音频采用率  8K或16K*/
        [_iFlySpeechRecognizer setParameter:@"16" forKey:[IFlySpeechConstant SAMPLE_RATE]];
        /**语音输入超时时间 单位：ms，默认30000*/
        [_iFlySpeechRecognizer setParameter:@"60000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        /**网络连接超时时间 单位：ms，默认20000*/
        [_iFlySpeechRecognizer setParameter:@"60000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        /**VAD前端点超时 范围：0-10000(单位ms)*/
        [_iFlySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant VAD_BOS]];
        /**VAD后端点超时。 可选范围：0-10000(单位ms)*/
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant VAD_EOS]];
        [_iFlySpeechRecognizer setDelegate:self];
    }
    return _iFlySpeechRecognizer;
}

- (RBVoiceRecordToastContentView *)speechView {
    if (!_speechView) {
        _speechView = [[RBVoiceRecordToastContentView alloc] initWithFrame:CGRectMake((screenWidth-120)/2, (screenHeight-120)/2, 120, 120)];
        _speechView.hidden = YES;
        _speechView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        _speechView.layer.cornerRadius = 6;
    }
    return _speechView;
}

#pragma mark -初始化讯飞
- (void)configIflyMSC{
    /**设置sdk的log等级，log保存在下面设置的工作路径中*/
    [IFlySetting setLogFile:LVL_ALL];
    /**打开输出在console的log开关*/
//    [IFlySetting showLogcat:YES];
    /**设置sdk的工作路径*/
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", iflyMSC_APPID];
    [IFlySpeechUtility createUtility:initString];
}

#pragma mark -开启监听
- (void)startIflyMSCListening:(RBIflyMSCSpeakType)speakType {
    
    switch (speakType) {
        case RBIflyMSCSpeakType_startListening:
        {
            if (![self.iFlySpeechRecognizer isListening]) {
                [[[AppDelegate sharedInstaceAppDelegate] currentViewController].view addSubview:self.speechView];
                self.speechView.hidden = NO;
                [self beginTimer];
                /**清空参数设置*/
                [self.iFlySpeechRecognizer setParameter:@"" forKey: [IFlySpeechConstant PARAMS]];
                /**不带标点符号*/
                [self.iFlySpeechRecognizer setParameter:@"0" forKey:[IFlySpeechConstant ASR_PTT]];
                [self.iFlySpeechRecognizer startListening];
            }
        }
            break;
        case RBIflyMSCSpeakType_stopListening:
        {
            self.speechView.hidden = YES;
            self.speechView.timeLabel.text = @"00:00";
            self.currentTimeStr = nil;
            [self invalidateTimer];
            [self.iFlySpeechRecognizer stopListening];
        }
            break;
        case RBIflyMSCSpeakType_cancel:
        {
            [self.iFlySpeechRecognizer cancel];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -IFlySpeechRecognizerDelegate协议 实现识别结果返回代理
- (void)onResults:(NSArray *) results isLast:(BOOL)isLast{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    NSString *resultFromJson = [self stringFromJson:resultString];
    if (resultFromJson.length>0) {
        if ([self.delegate respondsToSelector:@selector(managerSpeechResultChanged:)]) {
            [self.delegate managerSpeechResultChanged:resultFromJson];
        }
    }
    NSLog(@"当前获取的数据 :  %@",resultFromJson);
    if ([self.iFlySpeechRecognizer isListening]) {
        NSLog(@"正在识别");
    }
}

#pragma mark -不管成功还是失败都会调用该方法 识别会话结束返回代理
- (void)onCompleted:(IFlySpeechError *)errorCode {
    NSLog(@"错误原因 : %@ 【%d】",errorCode.errorDesc,errorCode.errorCode);
    //    [self.iFlySpeechRecognizer startListening];
    //    [self.iFlySpeechRecognizer cancel];
}

#pragma mark -停止录音回调
- (void) onEndOfSpeech{
    NSLog(@"结束录音");
    if ([self.delegate respondsToSelector:@selector(managerOnEndOfSpeech)]) {
        [self.delegate managerOnEndOfSpeech];
    }
}

#pragma mark -开始录音回调
- (void) onBeginOfSpeech{
    NSLog(@"开始录音");
    if ([self.delegate respondsToSelector:@selector(managerOnBeginOfSpeech)]) {
        [self.delegate managerOnBeginOfSpeech];
    }
}

#pragma mark -音量回调函数
- (void) onVolumeChanged:(int)volume{
    NSLog(@"音量回调函数=%d",volume);
    if ([self.delegate respondsToSelector:@selector(managerOnVolumeChanged:)]) {
        [self.delegate managerOnVolumeChanged:volume];
    }
    
    [self.speechView updateWithPower:volume];
}

- (void)beginTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(actionTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.myTimer = timer;
}

- (void)invalidateTimer{
    [self.myTimer invalidate];
    self.myTimer = nil;
}

- (void)actionTimer{
    if (self.currentTimeStr) {
        NSString * timerStr = [self timeFormatted:[self dateIntervalStr:self.currentTimeStr]];
        //  NSLog(@"当前获取的时间为 : %@",timerStr);
        self.speechView.timeLabel.text = timerStr;
    }else{
        self.currentTimeStr = [self getCurrentTimeString];
        
    }
}

- (NSString *)stringFromJson:(NSString *)params {
    if (params == NULL) {
        return nil;
    }
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    /**返回的格式必须为utf8的,否则发生未知错误*/
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:[params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    if (resultDic != nil) {
        NSArray *wordArray = [resultDic objectForKey:@"ws"];
        for (int i = 0; i < [wordArray count]; i++) {
            NSDictionary *wsDic = [wordArray objectAtIndex: i];
            NSArray *cwArray = [wsDic objectForKey:@"cw"];
            for (int j = 0; j < [cwArray count]; j++) {
                NSDictionary *wDic = [cwArray objectAtIndex:j];
                NSString *str = [wDic objectForKey:@"w"];
                [tempStr appendString: str];
            }
        }
    }
    return tempStr;
}

- (NSString *)timeFormatted:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    return [NSString stringWithFormat:@"%02d:%02d", minutes,seconds];
}

- (NSString*)getCurrentTimeString {
    //获取系统当前时间
    NSDate *currentDate = [NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    //输出currentDateString
    return currentDateString;
}

- (int )dateIntervalStr:(NSString *)startDateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date1 = [formatter dateFromString:startDateStr];
    NSDate *date2 = [NSDate date];
    NSTimeInterval aTimer = [date2 timeIntervalSinceDate:date1];
    // NSLog(@"当前间隔为 ： %@",[NSString stringWithFormat:@"%.0f",aTimer]);
    NSString *intervalDateStr = @"";
    if (aTimer < 60) {
        intervalDateStr = [NSString stringWithFormat:@"%.0f 秒前",aTimer];
    }else if (aTimer >= 60 && aTimer < 3600){
        intervalDateStr = [NSString stringWithFormat:@"%.0f 分钟前",aTimer/60];
    }else if (aTimer >= 3600 && aTimer < 3600*24){
        intervalDateStr = [NSString stringWithFormat:@"%.0f 小时前",aTimer/3600];
    }else if (aTimer >= 3600*24){
        intervalDateStr = [NSString stringWithFormat:@"%.0f 天前",aTimer/(3600*24)];
    }
    NSString * intervalTimer = [NSString stringWithFormat:@"%.0f",aTimer];// 获取间隔时间
    //    NSString * maxIntervalTime = [NSString stringWithFormat:@"%d",TimeInterval];// 允许的最大间隔
    //    if ([intervalTimer integerValue] >= [maxIntervalTime integerValue]) {
    //        return YES;
    //    }
    //    return NO;
    return [intervalTimer intValue];
    
}
@end
