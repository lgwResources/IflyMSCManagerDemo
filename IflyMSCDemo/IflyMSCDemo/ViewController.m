//
//  ViewController.m
//  IflyMSCDemo
//
//  Created by 刘功武 on 2019/4/11.
//  Copyright © 2019年 刘功武. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "RBIflyMSCManager.h"

#define UIColorFromRGBA(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:((float)((rgbValue & 0xFF000000) >> 24))/255.0]
#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1]
/**随机颜色*/
#define RANDOMCOLOR() UIColorFromRGB(rand()%256, rand()%256, rand()%256)

@interface ViewController ()<RBIflyMSCManagerDelegate>

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIButton *talkButton;

@end

@implementation ViewController

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 64, screenWidth-20, 200)];
        _textView.textColor = UIColorFromRGBA(0xff2c2c2c);
        _textView.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    }
    return _textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    [RBIflyMSCManager sharedManager].delegate = self;
    [self.view addSubview:self.textView];
    
    self.view.backgroundColor = UIColorFromRGBA(0xffeeeeee);
}

- (UIButton *)talkButton {
    if (!_talkButton) {
        _talkButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth-200)/2, screenHeight, 200, 40)];
        [_talkButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_talkButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        [_talkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _talkButton.backgroundColor = RANDOMCOLOR();
        [_talkButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [_talkButton.layer setMasksToBounds:YES];
        [_talkButton.layer setCornerRadius:4.0f];
        [_talkButton.layer setBorderWidth:0.5f];
        [_talkButton.layer setBorderColor:UIColorFromRGBA(0xff999999).CGColor];
        
        [_talkButton addTarget:self action:@selector(talkButtonUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_talkButton addTarget:self action:@selector(talkButtonDragInside:) forControlEvents:UIControlEventTouchDragInside];
        [_talkButton addTarget:self action:@selector(talkButtonDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
        [self.view addSubview:_talkButton];
    }
    return _talkButton;
}

#pragma mark -开始监听
- (void)talkButtonDragInside:(UIButton *)sender {
    [[RBIflyMSCManager sharedManager] startIflyMSCListening:RBIflyMSCSpeakType_startListening];
}

#pragma mark -结束监听
- (void)talkButtonUpInside:(UIButton *)sender {
    [[RBIflyMSCManager sharedManager] startIflyMSCListening:RBIflyMSCSpeakType_stopListening];
}

#pragma mark -取消监听
- (void)talkButtonDragOutside:(UIButton *)sender {
    [[RBIflyMSCManager sharedManager] startIflyMSCListening:RBIflyMSCSpeakType_cancel];
}

- (void)managerSpeechResultChanged:(NSString *)result {
    NSLog(@"result=%@",result);
    self.textView.text  = [NSString stringWithFormat:@"%@%@",self.textView.text,result];
}

- (void)keyboardWillAppear:(NSNotification *)noti {
    NSDictionary *info  = [noti userInfo];
    NSValue *value      = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardAnimationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize keyboardSize         = [value CGRectValue].size;
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        CGRect frame = self.talkButton.frame;
        frame.origin.y = screenHeight - keyboardSize.height - frame.size.height;
        self.talkButton.frame = frame;
    }];
}

- (void)keyboardWillDisappear:(NSNotification *)noti {
    NSDictionary *info  = [noti userInfo];
    CGFloat keyboardAnimationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        CGRect frame = self.talkButton.frame;
        frame.origin.y = screenHeight;
        self.talkButton.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
