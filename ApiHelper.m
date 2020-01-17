//
//  ApiHelper.m
//  WXT
//
//  Created by SGB on 15/11/9.
//  Copyright © 2015年 济南工程职业技术学院. All rights reserved.
//



#import "ApiHelper.h"

@implementation ApiHelper

singleton_implementation(ApiHelper)


/**
 *   1、 Post请求 所有的结果
 *
 *  @param URLString       <#URLString description#>
 *  @param parameters      <#parameters description#>
 *  @param completionBlock <#completionBlock description#>
 *  @param errorBlock      <#errorBlock description#>
 */
- (void)POST_AllResult:(NSString *)URLString
            parameters:(id)parameters
            targetView:(UIView*)targetView
             allResult:(CurrentResponseBlock)completionBlock
          errorHandler:(ErrorResponseBlock)errorBlock
{
    
    [ShowMessage showLoadingData:targetView];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    NSString *url_post = [self setStringBaseUrl:URLString];
    //    NSString *url_complete=[Utility URLEncode:url_short data:parameters];
    
    NSLog(@"URL--%@-参数--%@",url_post,parameters);
    [mgr POST:url_post parameters:parameters success:^(NSURLSessionDataTask *operation, id responseObject) {
        
   
        NSDictionary *dicResult = [[NSDictionary alloc]initWithDictionary:responseObject];
        
        kLog(@"请求字典：%@",parameters);
        kLog(@"返回数据：%@",dicResult);
        
        //          NSDictionary *dicResult = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        [MBProgressHUD hideAllHUDsForView:targetView animated:YES];
        ApiCodeType codeType;
        NSUInteger code = [dicResult[@"code"] integerValue];
        if ( 200 == code) {
            codeType = ApiCodeTypeData;
        }else if (201 == code) {
            codeType = ApiCodeTypeNoData;
        }else{
            codeType = ApiCodeTypeError;
        }
        //           completionBlock(dicResult[@"result"], dicResult[@"msg"], codeType,url_post);
        if (code==200)
        {
            completionBlock(dicResult, dicResult[@"msg"], codeType);
        }
        else
        {
//            completionBlock(dicResult, dicResult[@"msg"], codeType);
            [MBProgressHUD hideAllHUDsForView:targetView animated:YES];
            NSString *strMsg=dicResult[@"msg"];
            [ShowMessage showTextOnly:strMsg messageView:targetView];
            errorBlock();
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@",[error description]);
        
        [MBProgressHUD hideAllHUDsForView:targetView animated:YES];
        if (operation!=nil)
        {
            [operation cancel];
            operation=nil;
        }
        [self showFailMessage:error
                   targetView:targetView];
        errorBlock();
    }];
    
}
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
          errorHandler:(ErrorResponseBlock)errorBlock
{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    NSString *url_post = [self setStringBaseUrl:URLString];
    [mgr POST:url_post parameters:parameters success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        
        NSDictionary *dicResult = [[NSDictionary alloc]initWithDictionary:responseObject];
        
        ApiCodeType codeType;
        NSUInteger code = [dicResult[@"code"] integerValue];
        if ( 200 == code) {
            codeType = ApiCodeTypeData;
        }else if (201 == code) {
            codeType = ApiCodeTypeNoData;
        }else{
            codeType = ApiCodeTypeError;
        }
        if (code==200)
        {
            completionBlock(dicResult, dicResult[@"msg"], codeType);
        }
        else
        {
            errorBlock();
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        if (operation!=nil)
        {
            [operation cancel];
            operation=nil;
        }
        errorBlock();
    }];
    
}
-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
/**
 * 2、 Post请求 单纯的result
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
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    NSString *url_post = [self setStringBaseUrl:URLString];
    
    
    NSLog(@"URL--%@-参数--%@",url_post,parameters);
    [mgr POST:url_post
   parameters:parameters
      success:^(NSURLSessionDataTask *operation, id responseObject) {
          
          
          NSLog(@"获取的结果%@",responseObject);
          NSDictionary *dicResult = [[NSDictionary alloc]initWithDictionary:responseObject];
          
          
          [MBProgressHUD hideAllHUDsForView:targetView animated:YES];
          ApiCodeType codeType;
          NSUInteger code = [dicResult[@"code"] integerValue];
          if (code==200)
          {
              codeType = ApiCodeTypeData;
              completionBlock(dicResult[@"result"], dicResult[@"msg"], codeType);
          }
          else
          {
              [MBProgressHUD hideAllHUDsForView:targetView animated:YES];
              NSString *strMsg=dicResult[@"msg"];
              
              [ShowMessage showTextOnly:strMsg messageView:targetView];
              errorBlock();
          }
          
      } failure:^(NSURLSessionDataTask *operation, NSError *error) {
          [MBProgressHUD hideAllHUDsForView:targetView animated:YES];
          
          NSLog(@"%@",[error description]);
          if (operation!=nil)
          {
              [operation cancel];
              operation=nil;
          }
          [self showFailMessage:error
                     targetView:targetView];
          errorBlock();
      }];
}

/**
 * 3、 Post请求 图片上传
 */
- (void)POST_Pic:(NSString *)URLString
      parameters:(id)parameters
            pics:(NSMutableArray *)pics
      targetView:(UIView*)targetView
          result:(CurrentResponseBlock)completionBlock
    errorHandler:(ErrorResponseBlock)errorBlock

{
    
    [ShowMessage showLoadingData:targetView strMessage:@"上传中"];
    _isLoading = YES; // 正在加载
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url_post = [self setStringBaseUrl:URLString];
    // formData是遵守了AFMultipartFormData的对象
    NSLog(@"URL--%@-参数--%@",url_post,parameters);
    [manager POST:url_post parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for(int i=0;i<pics.count;i++)
        {
            // 将本地的文件上传至服务器
            NSData *dateImg = [pics objectAtIndex:i];
            NSString *strkey=@"img_pic";
            if (i!=0) {
                strkey=[NSString stringWithFormat:@"img_pic%i",i];
            }
            [formData appendPartWithFileData:dateImg name:strkey fileName:[NSString stringWithFormat:@"%i.jpg",i] mimeType:@"image/jpg"];
            
        }
    } success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        //        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dicResult =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        
        //NSDictionary *dicResult = [[NSDictionary alloc]initWithDictionary:responseObject];
        kLog(@"%@",dicResult);
        [MBProgressHUD hideAllHUDsForView:targetView animated:YES];
        ApiCodeType codeType;
        NSUInteger code = [dicResult[@"code"] integerValue];
        if ( 200 == code) {
            codeType = ApiCodeTypeData;
        }else if (201 == code) {
            codeType = ApiCodeTypeNoData;
        }else{
            codeType = ApiCodeTypeError;
        }
        
        if (code==200)
        {
            completionBlock(dicResult[@"result"], dicResult[@"msg"], codeType);
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:targetView animated:YES];
            NSString *strMsg=dicResult[@"msg"];
            kLog(@"%@",strMsg);
            [ShowMessage showTextOnly:strMsg messageView:targetView];
            errorBlock();
        }
        
        _isLoading = NO;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        NSLog(@"************");
        NSLog(@"****%@",[error description]);
        NSLog(@"************");
        _isLoading = NO;
        kLog(@"%@",error);
        [MBProgressHUD hideAllHUDsForView:targetView animated:YES];
        if (operation!=nil)
        {
            [operation cancel];
            operation=nil;
        }
        [self showFailMessage:error
                   targetView:targetView];
        errorBlock();
    }];
    
}

/**
 * 4、Post请求 不带提示信息
 */
- (void)POST_NoMessage:(NSString *)URLString
            parameters:(id)parameters
            targetView:(UIView*)targetView
                result:(CurrentResponseBlock)completionBlock
          errorHandler:(ErrorResponseBlock)errorBlock
{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    NSString *url_post = [self setStringBaseUrl:URLString];
    NSLog(@"URL--%@-参数--%@",url_post,parameters);
    [mgr POST:url_post
   parameters:[Utility ParamEncodeByDic:parameters]
      success:^(NSURLSessionDataTask *operation, id responseObject) {
          
          NSDictionary *dicResult = [[NSDictionary alloc]initWithDictionary:responseObject];
          
          
          //          NSDictionary *dicResult = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
          
          ApiCodeType codeType;
          NSUInteger code = [dicResult[@"code"] integerValue];
          if ( 200 == code) {
              codeType = ApiCodeTypeData;
          }else if (201 == code) {
              codeType = ApiCodeTypeNoData;
          }else{
              codeType = ApiCodeTypeError;
          }
          completionBlock(dicResult[@"result"], dicResult[@"msg"], codeType);
          
      } failure:^(NSURLSessionDataTask *operation, NSError *error) {
          if (operation!=nil)
          {
              [operation cancel];
              operation=nil;
          }
         [self showFailMessage:error
                targetView:targetView];
          errorBlock();
      }];
    
}
/**
 *  5.获取版本更新信息
 *
 */
- (void)POST_Update:(NSString *)URLString
         parameters:(id)parameters
         targetView:(UIView*)targetView
             result:(CurrentResponseBlock)completionBlock
       errorHandler:(ErrorResponseBlock)errorBlock
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    NSLog(@"URL--%@-参数--%@",URLString,parameters);
    [mgr POST:URLString
   parameters:[Utility ParamEncodeByDic:parameters]
      success:^(NSURLSessionDataTask *operation, id responseObject) {
//          NSLog(@"获取的结果%@",responseObject);

          NSDictionary *dicResult = [[NSDictionary alloc]initWithDictionary:responseObject];
          
          
          //          NSDictionary *dicResult = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
          
          ApiCodeType codeType;
          NSUInteger code = [dicResult[@"code"] integerValue];
          if ( 200 == code) {
              codeType = ApiCodeTypeData;
          }else if (201 == code) {
              codeType = ApiCodeTypeNoData;
          }else{
              codeType = ApiCodeTypeError;
          }
          completionBlock(dicResult[@"data"], dicResult[@"msg"], codeType);
          
      } failure:^(NSURLSessionDataTask *operation, NSError *error) {
          if (operation!=nil)
          {
              [operation cancel];
              operation=nil;
          }
          //          [self showFailMessage:error
          //                     targetView:targetView];
          errorBlock();
      }];
    

}

/**
 *  6.无错误信息提示
 *
 */
- (void)POST_NoError:(NSString *)URLString
         parameters:(id)parameters
         targetView:(UIView*)targetView
             result:(CurrentResponseBlock)completionBlock
       errorHandler:(ErrorResponseBlock)errorBlock
{
    
    [ShowMessage showLoadingData:targetView];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    NSString *url_post = [self setStringBaseUrl:URLString];
    
    NSLog(@"URL--%@-参数--%@",url_post,parameters);
    [mgr POST:url_post
   parameters:parameters
      success:^(NSURLSessionDataTask *operation, id responseObject) {
          
          
          NSLog(@"获取的结果%@",responseObject);
          NSDictionary *dicResult = [[NSDictionary alloc]initWithDictionary:responseObject];
          
          [MBProgressHUD hideAllHUDsForView:targetView animated:YES];
          ApiCodeType codeType;
          NSUInteger code = [dicResult[@"code"] integerValue];
          if ( 200 == code) {
              codeType = ApiCodeTypeData;
          }else if (201 == code) {
              codeType = ApiCodeTypeNoData;
          }else{
              codeType = ApiCodeTypeError;
          }
          completionBlock(dicResult[@"result"], dicResult[@"msg"], codeType);
          
      } failure:^(NSURLSessionDataTask *operation, NSError *error) {
          [MBProgressHUD hideAllHUDsForView:targetView animated:YES];
          
          NSLog(@"%@",[error description]);
          if (operation!=nil)
          {
              [operation cancel];
              operation=nil;
          }
          [self showFailMessage:error
                     targetView:targetView];
          errorBlock();
      }];
}
/**
 *  7.资金日报表
 *
 */
- (void)POST_CashResult:(NSString *)URLString
             parameters:(id)parameters
             targetView:(UIView*)targetView
                 result:(CurrentResponseBlock)completionBlock
           errorHandler:(ErrorResponseBlock)errorBlock {
    [ShowMessage showLoadingData:targetView];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    NSString *url_post = [self setStringBaseUrl:URLString];
    NSLog(@"URL--%@-参数--%@",url_post,parameters);
    [mgr POST:url_post
   parameters:parameters
      success:^(NSURLSessionDataTask *operation, id responseObject) {
          
          
          NSLog(@"获取的结果%@",responseObject);
          NSDictionary *dicResult = [[NSDictionary alloc]initWithDictionary:responseObject];
          
          
          [MBProgressHUD hideAllHUDsForView:targetView animated:YES];
          ApiCodeType codeType;
          NSUInteger code = [dicResult[@"code"] integerValue];
          if (code==200)
          {
              codeType = ApiCodeTypeData;
              completionBlock(dicResult, dicResult[@"msg"], codeType);
          }
          else
          {
              [MBProgressHUD hideAllHUDsForView:targetView animated:YES];
              NSString *strMsg=dicResult[@"msg"];
              
              [ShowMessage showTextOnly:strMsg messageView:targetView];
              errorBlock();
          }
          
      } failure:^(NSURLSessionDataTask *operation, NSError *error) {
          [MBProgressHUD hideAllHUDsForView:targetView animated:YES];
          
          NSLog(@"%@",[error description]);
          if (operation!=nil)
          {
              [operation cancel];
              operation=nil;
          }
          [self showFailMessage:error
                     targetView:targetView];
          errorBlock();
      }];
    
}
//***下载文件存入沙盒****//
/** 8、
 *  @brief  下载文件
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
//                      progress:(void (^)(float progress))progress
//
//{
//    // 固定地址
//    savedPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    savedPath = [savedPath stringByAppendingPathComponent:@"res"];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    //检查本地文件是否已存在
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@", savedPath, fileName];
//    
//    //检查附件是否存在
//    if ([fileManager fileExistsAtPath:filePath]) {
////        NSData *audioData = [NSData dataWithContentsOfFile:filePath];
//        
//    }else{
//        //创建附件存储目录
//        if (![fileManager fileExistsAtPath:savedPath]) {
//            [fileManager createDirectoryAtPath:savedPath withIntermediateDirectories:YES attributes:nil error:nil];
//        }
//        // 下载附件
//        NSURL* nsurl = [NSURL URLWithString:requestURL];
//        NSURLRequest* request = [NSURLRequest requestWithURL:nsurl];
//        NSURLSessionDataTask* operation = [[NSURLSessionDataTask alloc] initWithRequest:request];
//        [operation setInputStream:[NSInputStream inputStreamWithURL:nsurl]];
//        [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:filePath append:NO]];
//        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//            
//            float p = (float)totalBytesRead / totalBytesExpectedToRead;
//            progress(p);
//            
//        }];
//        
//        [operation setCompletionBlockWithSuccess:^(NSURLSessionDataTask *operation, id responseObject) {
//            NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:responseObject];
//            dicResult[@"path"] = filePath;
//            success(operation, dicResult);
//            
//            
//            NSLog(@"成功");
//        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
//            failure(operation, error);
//            
//            
//            NSLog(@"失败");
//        }];
//        [operation start];
//        
//    }
//}

/**
 * 9、Post请求 即时通讯缓存数据
 */
- (void)POST_IMMessage:(NSString *)URLString
            parameters:(id)parameters
                result:(CurrentResponseBlock)completionBlock
          errorHandler:(ErrorResponseBlock)errorBlock
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    NSString *url_post = [self setStringBaseUrl:URLString];
    NSLog(@"URL--%@-参数--%@",url_post,parameters);
    [mgr POST:url_post
   parameters:[Utility ParamEncodeByDic:parameters]
      success:^(NSURLSessionDataTask *operation, id responseObject) {
          NSDictionary *dicResult = [[NSDictionary alloc]initWithDictionary:responseObject];
          ApiCodeType codeType;
          NSUInteger code = [dicResult[@"code"] integerValue];
          if ( 200 == code) {
              codeType = ApiCodeTypeData;
          }else if (201 == code) {
              codeType = ApiCodeTypeNoData;
          }else{
              codeType = ApiCodeTypeError;
          }
          completionBlock(dicResult[@"result"], dicResult[@"msg"], codeType);
      } failure:^(NSURLSessionDataTask *operation, NSError *error) {
          if (operation!=nil)
          {
              [operation cancel];
              operation=nil;
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
    switch ([error code])
    {
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

#pragma mark - 拼接BaseUrl
/**
 * 拼接BaseURL
 */
- (NSString *)setStringBaseUrl:(NSString *)urlString
{
    NSString *str_url = [API_URL_BASE stringByAppendingString:urlString];
    return str_url;
}

@end
