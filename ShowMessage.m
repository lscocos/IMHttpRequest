//
//  ShowMessage.m
//  WXT
//
//  Created by SGB on 15/11/9.
//  Copyright © 2015年 济南工程职业技术学院. All rights reserved.
//

#import "ShowMessage.h"

@implementation ShowMessage
#pragma mark 纯文本的消息提示
+(void)showTextOnly:(NSString *)strMessage messageView:(UIView *)viewInfo
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewInfo animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = strMessage;
    hud.label.numberOfLines = 0;
    hud.margin=10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.0];
}
#pragma mark 自定义图片文字提示
+(void)showCustomViewWitnMessage:(NSString *)message inView:(UIView *)viewInfo
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewInfo animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *img_hudImage = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:img_hudImage];
    hud.square = YES;
    hud.label.font = [UIFont systemFontOfSize:18];
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.0f];
}
#pragma mark 信息加载时返回一个实例MBProgressHUD
+(MBProgressHUD *)showLoadingData:(UIView *)viewInfo
{
    __weak MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewInfo animated:YES];
    hud.label.text = @"正在加载";
    hud.label.font = [UIFont systemFontOfSize:12.0];
    hud.square = YES;
    hud.removeFromSuperViewOnHide=YES;
    return hud;
}
#pragma mark 信息加载时返回一个实例MBProgressHUD
+(MBProgressHUD *)showLoadingData:(UIView *)viewInfo strMessage:(NSString*)strMessage
{
    __weak MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewInfo animated:YES];
    hud.label.text = strMessage;
    hud.label.font = [UIFont systemFontOfSize:12.0];
    hud.square = YES;
    hud.removeFromSuperViewOnHide=YES;
    return hud;
}
#pragma mark 无信息提示视图
+(NoMessageView *)showNoMessageView:(UIView *)viewInfo msg:(NSString *)msg
{
    NoMessageView *ve_noMsg = [[NoMessageView alloc] init];
    ve_noMsg.msg = [Utility isBlankString:msg]?ve_noMsg.lb_msg.text:msg;
    [ve_noMsg showView:viewInfo];
    return ve_noMsg;
}
+(NoMessageView *)showNoMessageInView:(UIView *)viewInfo {
    NoMessageView *ve_noMsg = [[NoMessageView alloc] init];
    [ve_noMsg showInView:viewInfo];
    return ve_noMsg;
}
#pragma mark 工资首页无信息提示视图
+(NoMessageView *)showNoMessageViewInWagePage:(UIView *)viewInfo {
    NoMessageView *ve_noMsg = [[NoMessageView alloc] init];
    [ve_noMsg showViewWagePage:viewInfo];
    return ve_noMsg;
}

+(NoMessageView *)showNoMessageViewInGradeExamPage:(UIView *)viewInfo
{
    NoMessageView *ve_noMsg = [[NoMessageView alloc] init];
    ve_noMsg.msg = @"任务暂未下达";
    [ve_noMsg showViewGradeExamPage:viewInfo];
    return ve_noMsg;
}

+(void)hideNoMessageView:(UIView *)viewIfo
{
    for (UIView *view in viewIfo.subviews) {
        if ([view isKindOfClass:[NoMessageView class]]) {
            
            [view removeFromSuperview];
        }
    }
}
#pragma mark - 显示和隐藏alert
+(void)showAlertViewAndHide:(UIAlertView *)alert after:(double)time {
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}
@end

