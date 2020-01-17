//
//  JavaNetHelper.h
//  ERPAPP
//
//  Created by gaoming on 2019/5/27.
//  Copyright © 2019 山东开创集团股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CurrentResponseBlock)(id resultObject, NSString *msg, ApiCodeType codeType);
typedef void (^ErrorResponseBlock)();

@interface JavaNetHelper : NSObject

singleton_interface(JavaNetHelper);

/**
*   get请求 获取阿里云上app版本号和更新内容
*/
//- (void)getAppVerson:(NSString *)urlString result:(CurrentResponseBlock)completionBlock errorHandler:(ErrorResponseBlock)errorBlock;
- (void)updateAPPVersonWithRequestSuccess:(void(^)(NSString *trackViewUrl,NSString *versionStr,NSString *versionDesc))sucess;

/**
 * 1、 Post请求 单纯的result
 */
- (void)POST_Result:(NSString *)URLString
         parameters:(id)parameters
         targetView:(UIView*)targetView
             result:(CurrentResponseBlock)completionBlock
       errorHandler:(ErrorResponseBlock)errorBlock;
    
/**
*     2、 Post请求 单纯的result  不带提示信息
*/
- (void)POST_NoMessage:(NSString *)URLString
            parameters:(id)parameters
            targetView:(UIView*)targetView
                result:(CurrentResponseBlock)completionBlock
          errorHandler:(ErrorResponseBlock)errorBlock;

/**
 *  Post请求 单纯的result 返回数据的key为obj
 *
 *  @param URLString       <#URLString description#>
 *  @param parameters      <#parameters description#>
 *  @param targetView      <#targetView description#>
 *  @param completionBlock <#completionBlock description#>
 *  @param errorBlock      <#errorBlock description#>
 */
- (void)POST_JsonDataResult:(NSString *)URLString
                   parameters:(id)parameters
                   targetView:(UIView*)targetView result:(CurrentResponseBlock)completionBlock
                 errorHandler:(ErrorResponseBlock)errorBlock;

@end

NS_ASSUME_NONNULL_END
