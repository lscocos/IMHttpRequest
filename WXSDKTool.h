//
//  WXSDKTool.h
//  ERPAPP
//
//  Created by gaoming on 2019/12/10.
//  Copyright © 2019 山东开创集团股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,WXShareType) {
    WXShareTypeSession = 0, /**< 聊天界面    */
    WXShareTypeTimeline,    /**< 朋友圈     */
    WXShareTypeFavorite     /**< 收藏       */
};

@interface WXSDKTool : NSObject<WXApiDelegate>

+ (instancetype)sharedManager;

-(void) registerWXSDK;

-(void) shareWebUrlWithTitle:(NSString *)title desc:(NSString *)desc webpageUrl:(NSString *)webpageUrl thumbImage:(UIImage *)thumbImage type:(WXShareType)type;

@end

NS_ASSUME_NONNULL_END
