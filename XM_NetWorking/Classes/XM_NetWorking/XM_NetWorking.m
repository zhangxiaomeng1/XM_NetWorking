//
//  XM_NetWorking.m
//  AFNetworking
//
//  Created by 张晓檬 on 2018/3/30.
//

#import "XM_NetWorking.h"
#import <CommonCrypto/CommonCrypto.h>

#define UserDefaults                         [NSUserDefaults standardUserDefaults]
#define QXMAccess_token                      @"QXMAccess_token"
////-----阿里云线上
#define QXM_BASEAPP_URL                      @"https://"



@implementation XM_NetWorking

+ (instancetype)shareManager
{
    static XM_NetWorking *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    //请求头
    [instance addHttpHeader];
    return instance;
}
/**
 *  添加请求头
 *
 */
- (void)addHttpHeader
{
    //request headers
    [self.manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    [self.manager.requestSerializer  setValue:[UserDefaults objectForKey:QXMAccess_token] forHTTPHeaderField:@"access_token"];//token
//    [self.manager.requestSerializer  setValue:[QXMUtility getDeviceIDFA] forHTTPHeaderField:@"idfa"];//设备号
    [self.manager.requestSerializer  setValue:@"1" forHTTPHeaderField:@"typeCode"];//平台
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    [self.manager.requestSerializer  setValue:currentVersion forHTTPHeaderField:@"u_version"];
    [self.manager.requestSerializer  setValue:@"AppStore" forHTTPHeaderField:@"channel"];//渠道
}
- (AFHTTPSessionManager *)manager{
    if (_manager == nil) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@app/",QXM_BASEAPP_URL]]];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //        _manager.requestSerializer.timeoutInterval = 60;
    }
    return _manager;
}
/**
 *  GET 请求
 *
 *  @param path     url
 *  @param params   params
 *  @param delegate delegate
 *  @param alert    alert
 *  @param success  success
 *  @param failure  failure
 */
- (void)xsGetPath:(NSString *)path
           params:(id)params
         delegate:(id)delegate
     waitingAlert:(NSString *)alert
          success:(void(^)(id responseObject)) success
          failure:(void(^)(NSError* error)) failure
{
    
//    CKLog(@"请求的Url:%@%@",self.manager.baseURL,path);
    if (params) {
//        CKLog(@"========请求的参数========%@",params);
    }
    //网络加载窗
    [self showWaitingContent:alert inView:delegate];
    //
    [self.manager GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //隐藏网络加载窗
        [self hideWaitingInView:delegate];
        [self catchNetResWithResInfo:responseObject path:path delegate:delegate success:success error:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏网络加载窗
        [self hideWaitingInView:delegate];
        //网络请求错误处理
//        NSDictionary *userInfo = error.userInfo;
//        if ([userInfo isKindOfClass:[NSDictionary class]]) {
//            NSString *description = [userInfo objectForKey:@"NSLocalizedDescription"];
//            if ([QXMUtility isStringOk:description]) {
//                [SVProgressHUD QXMShowMessageWithInfo:description];
//            }
//        } else{
//            [SVProgressHUD QXMShowMessageWithInfo:@"请求失败，请稍后重试"];
//        }
        failure(error);
    }];
}

/**
 *  POST 请求
 *
 *  @param path     url
 *  @param params   params
 *  @param delegate delegate
 *  @param alert    alert
 *  @param success  success
 *  @param failure  failure
 */
- (void)xsPostPath:(NSString *)path
            params:(id)params
          delegate:(id)delegate
      waitingAlert:(NSString *)alert
           success:(void(^)(id responseObject)) success
           failure:(void(^)(NSError* error)) failure
{
//    CKLog(@"请求的Url:%@%@",self.manager.baseURL,path);
    if (params) {
//        CKLog(@"========请求的参数========%@",params);
    }
    //网络加载窗
    [self showWaitingContent:alert inView:delegate];
    [self.manager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //隐藏网络加载窗
        [self hideWaitingInView:delegate];
        [self catchNetResWithResInfo:responseObject path:path delegate:delegate success:success error:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏网络加载窗
        [self hideWaitingInView:delegate];
        //网络请求错误处理
//        NSDictionary *userInfo = error.userInfo;
//        if ([userInfo isKindOfClass:[NSDictionary class]]) {
//            NSString *description = [userInfo objectForKey:@"NSLocalizedDescription"];
//            if ([QXMUtility isStringOk:description]) {
//                [SVProgressHUD QXMShowMessageWithInfo:description];
//            }
//        } else{
//            [SVProgressHUD QXMShowMessageWithInfo:@"请求失败，请稍后重试"];
//        }
        failure(error);
    }];
}

/**
 *  上传头像的网络请求
 *
 *  @param path     接口地址
 *  @param image    需要上传的image
 *  @param name     name
 *  @param delegate 代理
 *  @param alert    等待窗的内容，可以为空
 *  @param params   参数
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
-(void)xsUploadPath:(NSString *)path
              image:(UIImage *)image
               name:(NSString *)name
           fileName:(NSString *)fname
           delegate:(id)delegate
       wiatingAlert:(NSString *)alert
             params:(NSDictionary *)params
            success:(void(^)(id responseObject)) success
            failure:(void(^)(NSError* error)) failure
{
    //判断网络状态
//    if (![QXMUtility checkNetworkStatusBuTixing]) {
//        [SVProgressHUD QXMShowMessageWithInfo:@"您的网络好像不太给力，请稍后再试"];
//        return;
//    }
//    CKLog(@"请求的Url:%@%@",self.manager.baseURL,path);
    if (params) {
//        CKLog(@"========请求的参数========%@",params);
    }
    //网络加载窗
    [self showWaitingContent:alert inView:delegate];
    
    [self.manager POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //将图片装换为二进制格式--UIImageJPEGRepresentation第一个参数为要上传的图片,第二个参数是图片压缩的倍数
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        CGFloat length = [imageData length] / 1024.0;
        if (length > 100) {
            imageData = UIImageJPEGRepresentation(image, 0.1);
        }
        [formData appendPartWithFileData:imageData name:@"picfile" fileName:@"HeadImage.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideWaitingInView:delegate];
        [self catchNetResWithResInfo:responseObject path:path delegate:delegate success:success error:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideWaitingInView:delegate];
    }];
}


/**
 *  网络请求成功后，统一处理方法
 *
 *  @param info     请求返回来的数据
 *  @param success  成功的回调
 *  @param failure  失败的回调
 *  @param delegate 代理
 *  @param path     nil
 */
-(void)catchNetResWithResInfo:(id )info
                         path:(NSString *)path
                     delegate:(id) delegate
                      success:(void(^)(id resBody)) success
                        error:(void(^)(NSError* error)) failure

{
    /*
     200 成功
     */
    //网络请求成功
    NSDictionary * dic = (NSDictionary *)info;
//    CKLog(@"网络请求返回来的数据***********************\n%@\n*******************",info);
    NSNumber *resCode = [dic objectForKey:@"code"];
    switch (resCode.integerValue) {
            case 200: //请求成功
        {
            id data = [dic objectForKey:@"data"];
            success(data);
        }
            break;
            //            case 401: //401 用户未登录
            //        {
            //            //被顶号，清除授权信息的密码
            //            // 清除账号密码
            //            [SVProgressHUD QXMShowMessageWithInfo:[dic objectForKey:@"message"]];
            //            //修改本地用户信息
            //            [QXMUtility loginOutData:nil];
            //        }
            break;
            
            case 820:// 列表为空
        {
            id data = [dic objectForKey:@"data"];
            success(data);
        }
            break;
            
        default: //请求处理失败
        {
//            [SVProgressHUD QXMShowMessageWithInfo:[dic objectForKey:@"message"]];
        }
            break;
    }
}

- (void)showWaitingContent:(NSString *)alert inView:(id)delegate
{
    //    if (![alert isEqualToString:@"NOLOADING"]) {
    //        if ([delegate isKindOfClass:[UIView class]]) {
    //            [XSHelper showLoadingContent:alert inView:delegate];
    //        }else if ([delegate isKindOfClass:[UIViewController class]]){
    //            UIViewController *vc = (UIViewController *)delegate;
    //            [XSHelper showLoadingContent:alert inView:vc.view];
    //        }
    //    }
}

- (void)hideWaitingInView:(id)delegate
{
    //    if ([delegate isKindOfClass:[UIView class]]) {
    //        [XSHelper hideLoadingInView:delegate];
    //    }else if ([delegate isKindOfClass:[UIViewController class]]){
    //        UIViewController *vc = (UIViewController *)delegate;
    //        [XSHelper hideLoadingInView:vc.view];
    //    }
}

- (void)downloadVideo:(NSString *)urlString completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
{
    // http://vedio.xiangshang360.com/4D5AF02D66D1FEEFC72899D783851471.mp4
    
    NSURL *cachesDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    cachesDirectoryURL = [cachesDirectoryURL URLByAppendingPathComponent:[[self md5HexDigest:urlString] stringByAppendingString:@".mp4"]];
    NSData *data = [NSData dataWithContentsOfURL:cachesDirectoryURL];
    if (data) {
        completionHandler(nil,cachesDirectoryURL,nil);
    }else{
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionDownloadTask *downloadTask = [self.manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            // 保存在cache目录下
            return [NSURL URLWithString:cachesDirectoryURL.relativeString];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//            CKLog(@"File downloaded to: %@", filePath);
            completionHandler(response,filePath,error);
        }];
        [downloadTask resume];
    }
}
- (NSString *)md5HexDigest:(NSString*)input
{
//    if (![QXMUtility isStringOk:input]) {
//        return @"";
//    }
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}












@end
