//
//  ApiHelper.h
//  WXT
//
//  Created by SGB on 15/11/9.
//  Copyright © 2015年 济南工程职业技术学院. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum ApiCodeType{
//    ApiCodeTypeOK       = 0, // 1.操作成功
    ApiCodeTypeData     = 0, // 3.有数据
    ApiCodeTypeNoData   = 1,// 4.无数据
     ApiCodeTypeError   = 2, // 2.操作失败
} ApiCodeType;

typedef enum ApiStatus {
    ApiStatusUnknown    = -1,// 0.未知网络
    ApiStatusNot        = 0, // 1.没有网络
    ApiStatusWWAN       = 1, // 2.自带网络
    ApiStatusWiFi       = 2 // 3.WIFI
} ApiStatus;



typedef void (^CurrentResponseBlock)(id resultObject, NSString *msg, ApiCodeType codeType);
typedef void (^ErrorResponseBlock)();

@interface ApiHelper : NSObject
@property(nonatomic,assign) BOOL isLoading;
singleton_interface(ApiHelper);



/**
 *   1、 Post请求 所有的结果
 *
 */
- (void)POST_AllResult:(NSString *)URLString
  parameters:(id)parameters
  targetView:(UIView*)targetView
  allResult:(CurrentResponseBlock)completionBlock
errorHandler:(ErrorResponseBlock)errorBlock;


/**
 *   1-1、 Post请求 即时通讯 所有的结果 无提示信息
 *
 *  @param URLString       <#URLString description#>
 *  @param parameters      <#parameters description#>
 *  @param completionBlock <#completionBlock description#>
 *  @param errorBlock      <#errorBlock description#>
 */
- (void)POST_IMAllResult:(NSString *)URLString
                 parameters:(id)parameters
                  allResult:(CurrentResponseBlock)completionBlock
               errorHandler:(ErrorResponseBlock)errorBlock;

/**
 * 2、 Post请求 单纯的result
 */
- (void)POST_Result:(NSString *)URLString
  parameters:(id)parameters
  targetView:(UIView*)targetView
  result:(CurrentResponseBlock)completionBlock
errorHandler:(ErrorResponseBlock)errorBlock;


/**
 * 3、 Post请求 图片上传
 */
- (void)POST_Pic:(NSString *)URLString
      parameters:(id)parameters
            pics:(NSArray *)pics
      targetView:(UIView*)targetView
          result:(CurrentResponseBlock)completionBlock
    errorHandler:(ErrorResponseBlock)errorBlock;

/**
 * 4、Post请求 不带提示信息
 */
- (void)POST_NoMessage:(NSString *)URLString
         parameters:(id)parameters
         targetView:(UIView*)targetView
             result:(CurrentResponseBlock)completionBlock
       errorHandler:(ErrorResponseBlock)errorBlock;

/**
 *  3.提示信息
 *
 */
- (void)showFailMessage:(NSError *)error
             targetView:(UIView *)targetView;

/**
 *  5.获取版本更新信息
 *
 */
- (void)POST_Update:(NSString *)URLString
              parameters:(id)parameters
              targetView:(UIView*)targetView
                  result:(CurrentResponseBlock)completionBlock
            errorHandler:(ErrorResponseBlock)errorBlock;
/**
 *  6.无错误信息提示
 *
 */
- (void)POST_NoError:(NSString *)URLString
parameters:(id)parameters
targetView:(UIView*)targetView
result:(CurrentResponseBlock)completionBlock
        errorHandler:(ErrorResponseBlock)errorBlock;
/**
 *  7.资金日报表
 *
 */
- (void)POST_CashResult:(NSString *)URLString
             parameters:(id)parameters
             targetView:(UIView*)targetView
                 result:(CurrentResponseBlock)completionBlock
           errorHandler:(ErrorResponseBlock)errorBlock;
/** 8、
 *  @brief  下载文件 并缓存沙盒
 *  @param paramDic   附加post参数
 *  @param requestURL 请求地址
 *  @param savedPath  保存 在磁盘的位置
 *  @param fileName   文件名
 *  @param success    下载成功回调
 *  @param failure    下载失败回调
 *  @param progress   实时下载进度回调
 */
//- (void)downloadFileWithOption:(NSDictionary *)paramDic
//                 withRequestURL:(NSString*)requestURL
//                     savedPath:(NSString*)savedPath
//                      fileName:(NSString*)fileName
//               downloadSuccess:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
//               downloadFailure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure
//                      progress:(void (^)(float progress))progress;
/**
 * 9、Post请求 即时通讯缓存数据
 */
- (void)POST_IMMessage:(NSString *)URLString
            parameters:(id)parameters
                result:(CurrentResponseBlock)completionBlock
          errorHandler:(ErrorResponseBlock)errorBlock;
@end
