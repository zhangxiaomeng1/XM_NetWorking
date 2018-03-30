//
//  XM_NetWorking.h
//  AFNetworking
//
//  Created by 张晓檬 on 2018/3/30.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface XM_NetWorking : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *manager;

+ (instancetype)shareManager;

- (void)xsGetPath:(NSString *)path
           params:(id)params
         delegate:(id)delegate
     waitingAlert:(NSString *)alert
          success:(void(^)(id responseObject)) success
          failure:(void(^)(NSError* error)) failure;

- (void)xsPostPath:(NSString *)path
            params:(id)params
          delegate:(id)delegate
      waitingAlert:(NSString *)alert
           success:(void(^)(id responseObject)) success
           failure:(void(^)(NSError* error)) failure;

-(void)xsUploadPath:(NSString *)path
              image:(UIImage *)image
               name:(NSString *)name
           fileName:(NSString *)fname
           delegate:(id)delegate
       wiatingAlert:(NSString *)alert
             params:(NSDictionary *)params
            success:(void(^)(id responseObject)) success
            failure:(void(^)(NSError* error)) failure;

- (void)downloadVideo:(NSString *)urlString completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

@end
