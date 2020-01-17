//
//  WXSDKTool.m
//  ERPAPP
//
//  Created by gaoming on 2019/12/10.
//  Copyright © 2019 山东开创集团股份有限公司. All rights reserved.
//

#import "WXSDKTool.h"

@implementation WXSDKTool

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXSDKTool *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void) registerWXSDK {
    [WXApi registerApp:WECHAT_APPID]; // 分享
}

-(void) shareWebUrlWithTitle:(NSString *)title desc:(NSString *)desc webpageUrl:(NSString *)webpageUrl thumbImage:(UIImage *)thumbImage type:(WXShareType)type{
    if (![WXApi isWXAppInstalled]) {
        [ShowMessage showTextOnly:@"请先安装微信" messageView:kKeyWindow];
        return;
    }
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = webpageUrl;
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = desc;
    [message setThumbImage:thumbImage];
    message.mediaObject = webpageObject;
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    if (type == WXShareTypeSession) {
        req.scene = WXSceneSession;
    } else if (type == WXShareTypeTimeline) {
        req.scene = WXSceneTimeline;
    } else {
        req.scene = WXSceneFavorite;
    }
    
    [WXApi sendReq:req];
}

#pragma mark - WXApiDelegate
/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp {
    NSLog(@"%d,%@,%d",resp.errCode,resp.errStr,resp.type);
    if([resp isKindOfClass:[SendMessageToWXResp class]]) {
        SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
        NSLog(@"RESP:lang:%@,country:%@\n", messageResp.lang, messageResp.country);
        //这里不再返回用户是否分享完成事件，即原先的cancel事件和success事件将统一为success事件
        //        if(req.errCode == 0){
        //            //分享成功
        //        }
    }
}

-(void)onReq:(BaseReq*)req {
    // just leave it here, WeChat will not call our app
}

@end
