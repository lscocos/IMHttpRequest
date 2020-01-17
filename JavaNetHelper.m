//
//  JavaNetHelper.m
//  ERPAPP
//
//  Created by gaoming on 2019/5/27.
//  Copyright © 2019 山东开创集团股份有限公司. All rights reserved.
//

#import "JavaNetHelper.h"
#import "LoginViewController.h"

@implementation JavaNetHelper

singleton_implementation(JavaNetHelper)

/**
 *  Post请求 单纯的result 返回数据的key为obj
 *
 *  @param URLString       <#URLString description#>
 *  @param parameters      <#parameters description#>
 *  @param targetView      <#targetView description#>
 *  @param completionBlock <#completionBlock description#>
 *  @param errorBlock      <#errorBlock description#>
 */
- (void)getAppVerson:(NSString *)urlString result:(CurrentResponseBlock)completionBlock errorHandler:(ErrorResponseBlock)errorBlock
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];//设置相应内容类型
    
    [mgr POST:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"%@",responseObject);
        if (completionBlock) {
            completionBlock(responseObject, @"", ApiCodeTypeData);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

/**
 *  Post请求 单纯的result 返回数据的key为obj
 *
 *  @param URLString       <#URLString description#>
 *  @param parameters      <#parameters description#>
 *  @param targetView      <#targetView description#>
 *  @param completionBlock <#completionBlock description#>
 *  @param errorBlock      <#errorBlock description#>
 */
- (void)POST_Result:(NSString *)URLString
         parameters:(id)parameters
         targetView:(UIView*)targetView
             result:(CurrentResponseBlock)completionBlock
       errorHandler:(ErrorResponseBlock)errorBlock
{
    
    [ShowMessage showLoadingData:targetView];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];//设置相应内容类型
    if (kSessionID && [kSessionID length]>0) {
        [mgr.requestSerializer setValue:kSessionID forHTTPHeaderField:@"x-auth-token"];
    }

    NSMutableDictionary *finalParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *url_post = [JAVA_URL_BASE stringByAppendingString:URLString];
    NSLog(@"\nURL: %@ \n参数:%@",url_post,parameters);
    [mgr POST:url_post parameters:finalParameters
      success:^(NSURLSessionDataTask *operation, id responseObject) {
          NSDictionary *responseDic = [[NSDictionary alloc] initWithDictionary:responseObject];

          [MBProgressHUD hideAllHUDsForView:targetView animated:YES];
          ApiCodeType codeType;
          NSUInteger code = [responseDic[@"code"] integerValue];
          if (code == 0) {
              NSLog(@"\n获取结果:%@",responseObject);
              codeType = ApiCodeTypeData;
              completionBlock(responseDic[@"obj"], responseDic[@"msg"], codeType);
          }
          else if (code == 40001) {
//              kLogout;
          } else {
              [MBProgressHUD hideAllHUDsForView:targetView animated:YES];
              NSString *strMsg = responseDic[@"msg"];

              [ShowMessage showTextOnly:strMsg messageView:targetView];
              errorBlock();
          }

      } failure:^(NSURLSessionDataTask *operation, NSError *error) {
          [MBProgressHUD hideAllHUDsForView:targetView animated:YES];
          NSDictionary *errorDic = operation.response;
          if ([errorDic[@"code"] integerValue] == 40001) {
//              kLogout;
          } else {
              [self showFailMessage:error
                         targetView:kKeyWindow];
          }
          if (operation!= nil) {
              [operation cancel];
              operation = nil;
          }
          errorBlock();
      }];
}

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
         targetView:(UIView*)targetView
             result:(CurrentResponseBlock)completionBlock
       errorHandler:(ErrorResponseBlock)errorBlock
{
    [ShowMessage showLoadingData:targetView];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    // 请求头
    NSString *accessPath =  [NSString stringWithFormat:@"%@%@",JAVA_URL_BASE,URLString];
    //        NSLog(@"发送请求url=%@,params=%@",accessPath,params);
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:accessPath parameters:nil error:nil];
    [request setHTTPBody:data];
    request.timeoutInterval = 10.f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if (kSessionID && [kSessionID length]>0) {
        [request setValue:kSessionID forHTTPHeaderField:@"x-auth-token"];
    }
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"\nURL: %@ \n参数: %@ \n responseObject:%@",accessPath,parameters,responseObject);
        [MBProgressHUD hideAllHUDsForView:targetView animated:YES];
        if (!error) {
            NSUInteger code = [responseObject[@"code"] integerValue];
            if (code == 0) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    // 请求成功数据处理
                    completionBlock(responseObject[@"obj"], responseObject[@"msg"], ApiCodeTypeData);
                } else {
                    [ShowMessage showTextOnly:@"返回数据不是字典" messageView:targetView];
                    errorBlock();
                }
            }else if (code == 40001) {
//                kLogout;
            }else{
                NSString *strMsg = responseObject[@"msg"];
                [ShowMessage showTextOnly:strMsg messageView:targetView];
                errorBlock();
            }
        } else {
            NSLog(@"请求失败error=%@", error);
            NSString *strMsg = responseObject[@"msg"];
            [ShowMessage showTextOnly:strMsg messageView:targetView];
            errorBlock();
        }
    }];
    
    [task resume];
}

- (void)POST_NoMessage:(NSString *)URLString
            parameters:(id)parameters
            targetView:(UIView*)targetView
                result:(CurrentResponseBlock)completionBlock
          errorHandler:(ErrorResponseBlock)errorBlock
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];//设置相应内容类型

    
    NSString *sessionID = kSessionID;
    NSLog(@"----------sessionID:%@",sessionID);
    if (sessionID && [sessionID length]>0) {
        [mgr.requestSerializer setValue:sessionID forHTTPHeaderField:@"x-auth-token"];
    }
    
    NSString *url_post = [JAVA_URL_BASE stringByAppendingString:URLString];
    NSLog(@"URL--%@-参数--%@",url_post,parameters);
    //[Utility ParamEncodeByDic:parameters]
    [mgr POST:url_post parameters:parameters
      success:^(NSURLSessionDataTask *operation, id responseObject) {
          
          NSDictionary *responseDic = [[NSDictionary alloc] initWithDictionary:responseObject];
          ApiCodeType codeType;
          NSUInteger code = [responseDic[@"code"] integerValue];
          if (code == 0) {
              NSLog(@"\n获取结果:%@",responseObject[@"obj"]);
              codeType = ApiCodeTypeData;
              completionBlock(responseDic[@"obj"], responseDic[@"msg"], codeType);
          } else if (code == 40001) {
//              kLogout;
          } else {
              NSString *strMsg = responseDic[@"msg"];
              
              [ShowMessage showTextOnly:strMsg messageView:targetView];
              errorBlock();
          }
          
      } failure:^(NSURLSessionDataTask *operation, NSError *error) {
          NSDictionary *errorDic = operation.response;
          NSLog(@"++++%@",errorDic);
          if ([errorDic[@"code"] integerValue] == 40001) {
              [ShowMessage showTextOnly:errorDic[@"msg"] messageView:kKeyWindow];
//              kLogout;
          } else {
              [self showFailMessage:error
                         targetView:kKeyWindow];
          }
          if (operation!= nil) {
              [operation cancel];
              operation = nil;
          }
          errorBlock();
      }];
    
}

#pragma mark - 请求失败之后提示信息
//请求失败之后提示信息
- (void)showFailMessage:(NSError *)error
             targetView:(UIView *)targetView
{
    NSString *strMsg=nil;
    long errorCode=[error code];
    
    NSLog(@"错误码是%li",errorCode);
    switch ([error code]) {
        case -1009://网络无连接。模拟器一直返回此状态。
            strMsg=@"当前网络不可用，请检查网络设置";
            break;
        case -1001://网络请求超时
            strMsg=@"网络请求超时";
            break;
        default:
            strMsg=@"系统服务忙，请稍后操作";
            break;
    }
    [ShowMessage showTextOnly:strMsg messageView:targetView];
}

#pragma mark --- 更新app版本
- (void)updateAPPVersonWithRequestSuccess:(void(^)(NSString *trackViewUrl,NSString *versionStr,NSString *versionDesc))sucess
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr POST:Java_AppStore_Verson parameters:@{} success:^(NSURLSessionDataTask * _Nonnull operation, id  _Nonnull responseObject) {
            
        //具体实现为
        NSArray *arr = [responseObject objectForKey:@"results"];
        NSDictionary *dic = [arr firstObject];
        NSString *versionStr = [dic objectForKey:@"version"];
        NSString *trackViewUrl = [dic objectForKey:@"trackViewUrl"];
        NSString *versionDesc = [dic objectForKey:@"releaseNotes"];//更新日志
        
    //        NSString *trackName = [dic objectForKey:@"trackName"];
    //        NSString* buile = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString*) kCFBundleVersionKey];build号
            
        if ([Utility isBlankString:versionStr]) return ;
        NSString* thisVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        if ([Utility compareVersionsFormAppStore:versionStr WithAppVersion:thisVersion]) {
            sucess(trackViewUrl,versionStr,versionDesc);
        } else {
            NSLog(@"已是最新版本");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"请检查网络");
    }];
}

@end
