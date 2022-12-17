//
//  ViewController.m
//  CallFaceID
//
//  Created by 崔先生的MacBook Pro on 2022/9/16.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self faceID];
}

- (void)faceID {
    
    //创建LAContext
    LAContext *context = [[LAContext alloc] init];
    
    //这个属性是设置生物验证失败之后的弹出框的选项
    context.localizedFallbackTitle = @"使用账号密码登陆";
    
    //错误信息
    NSError *error = nil;
    //判断设备是否支持Face ID或Touch ID
    BOOL isUseFaceOrTouchID = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (isUseFaceOrTouchID) {
        //这个是用来验证TouchID的，会有弹出框出来
        //字符串参数为验证失败时提示语
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"验证失败！或许你...不是本人？" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"验证成功");
                });
                
            } else {
                NSLog(@"%@", error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel: {
                        NSLog(@"系统取消授权，如其他APP切入");
                        break;
                    }
                    case LAErrorUserCancel: {
                        NSLog(@"用户取消验证Face ID");
                        break;
                    }
                    case LAErrorAuthenticationFailed: {
                        NSLog(@"授权失败");
                        break;
                    }
                    case LAErrorPasscodeNotSet: {
                        NSLog(@"系统未设置密码");
                        break;
                    }
                    case LAErrorBiometryNotAvailable: {
                        NSLog(@"设备Face ID不可用，例如未打开");
                        break;
                    }
                    case LAErrorBiometryNotEnrolled: {
                        NSLog(@"设备Face ID不可用，用户未录入");
                        break;
                    }
                    case LAErrorUserFallback: {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"用户选择输入密码，切换主线程处理");
                        }];
                        break;
                    }
                    default: {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"其他情况，切换主线程处理");
                        }];
                        break;
                    }
                }
            }
        }];
        
    } else {
        NSLog(@"不支持Face ID或Touch ID");
        switch (error.code) {
            case LAErrorBiometryNotEnrolled: {
                NSLog(@"Face ID未注册");
                break;
            }
            case LAErrorPasscodeNotSet: {
                NSLog(@"未设置密码");
                break;
            }
            default: {
                NSLog(@"Face ID不可用");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
    }
    
}



@end
