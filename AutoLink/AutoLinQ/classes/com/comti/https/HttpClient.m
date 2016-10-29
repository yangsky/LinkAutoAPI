//
//  HttpClient.m
//  AutoLinQ
//
//  Created by mac on 16/3/14.
//
//

#import "HttpClient.h"
#import "JSONKit.h"
#import "Message.h"
#import "Payload.h"

@implementation HttpClient

- (void)post:(NSString *)urlString header:(NSDictionary *)headers parameters:(NSDictionary *)parameters contentType:(NSString *)contentType responseHandler:(ResponseHandler)responseHandler failure:(FailureHandler)failureHandler {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // set request
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];
    // set request headers
    for (NSString *key in headers.allKeys) {
        [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
    }
    
    // set response
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:contentType];
    
    // if https, set securityPolicy
    if ([urlString hasPrefix:@"https://"]) {
        manager.securityPolicy = [self customSecurityPolicy];
    }
    
    // POST
    [manager POST:urlString parameters:parameters success:responseHandler failure:failureHandler];
}

+ (void)POST:(NSString *)URLString parameters:(id)parameters finish:(void (^)(id responseObject))finish {
    
    NSDictionary *dict;
    
    // parameters to dictionary
    if ([parameters isKindOfClass:[NSString class]]) {
        NSString *json = parameters;
        dict = [json objectFromJSONString];
    } else if ([parameters isKindOfClass:[NSDictionary class]]) {
        dict = parameters;
    } else {
        // parameters error
        if (finish) {
            dispatch_async(dispatch_get_main_queue(), ^{
                finish([HttpClient responseObject:nil localError:kParameterError]);
            });
            return;
        }
    }

    NSString *funcID = dict[kFuncID];
    NSString *pkgNum = dict[kPkgNum];
    NSString *isEncryption = dict[kIsEncryption];
    NSString *isCompress = dict[kIsCompress];
    NSString *data = dict[kData];
    
    NSInteger iPkgNum = [pkgNum intValue];
    
    // parameters check
    if (funcID &&
        iPkgNum>0 &&
        ([isEncryption isEqualToString:@"0"] || [isEncryption isEqualToString:@"1"]) &&
        ([isCompress isEqualToString:@"0"] || [isCompress isEqualToString:@"1"]) &&
        data) {
        
        // generate commom message
        NSString *payLoadJson = [Payload generateCommomMsgWithFunid:funcID pkgNum:pkgNum isEncryption:isEncryption isCompress:isCompress data:data];
        // commom message to dictionary
        NSDictionary *payLoadDict = [payLoadJson objectFromJSONString];

        // for package
        NSString *allData = payLoadDict[kData];
        NSUInteger pkgLength = allData.length/iPkgNum;

        // package number > data.length
        if (iPkgNum > allData.length) {
            // parameters error
            if (finish) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    finish([HttpClient responseObject:nil localError:kParameterError]);
                });
            }
        }

        // http parameters Array
        NSMutableArray *parametersArray = [NSMutableArray array];
        // package
        for (int idx=0; idx<iPkgNum; idx++) {
            
            NSString *pkgIndex = [NSString stringWithFormat:@"%d", idx];
            NSString *pkgData = @"";
            if (idx != (iPkgNum-1)) {
                pkgData = [allData substringWithRange:NSMakeRange(idx*pkgLength, pkgLength)];
            } else {
                pkgData = [allData substringFromIndex:(idx*pkgLength)];
            }

            NSMutableDictionary *paramterDict = [NSMutableDictionary dictionaryWithDictionary:payLoadDict];
            [paramterDict setObject:pkgIndex forKey:kPkgIndex];
            [paramterDict setObject:pkgData forKey:kData];
            
            [parametersArray addObject:paramterDict];
        }

        [HttpClient POST:URLString parameters:parametersArray success:^(id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                finish([HttpClient responseObject:responseObject localError:kNoError]);
            });
        } failure:^(NSError *error) {
            // http error
            if (finish) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    finish([HttpClient responseObject:nil localError:kHttpError]);
                });
            }
        }];
    } else {
        // parameters error
        if (finish) {
            dispatch_async(dispatch_get_main_queue(), ^{
                finish([HttpClient responseObject:nil localError:kParameterError]);
            });
        }
    }
}

// real http post
+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    // http parameters Array
    NSMutableArray *array = (NSMutableArray *)parameters;
    if (array.count == 0) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    NSDictionary *parametersDictionary = (NSDictionary *)[array firstObject];
    NSLog(@"parameters:%@", parametersDictionary);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:URLString parameters:parametersDictionary success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"response:%@", responseObject);
        if (success) {

            NSDictionary *responseDictionary = (NSDictionary *)responseObject;
            
            // http success
            if ([responseDictionary[kErrorCode] intValue] == 0) {
                
                NSDictionary *dataDictionary = (NSDictionary *)responseDictionary[kData];
                if ([dataDictionary allKeys].count > 0) { // all request end
                    
                    success(responseObject);
                } else {
                    
                    // not all request end
                    [array removeObjectAtIndex:0];
                    [HttpClient POST:URLString parameters:array success:success failure:failure];
                }
            } else {
                success(responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (NSString *)responseObject:(id)responseObject localError:(int)localErrorCode {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    if (responseObject) {
        
        NSDictionary *responseDictionary = (NSDictionary *)responseObject;

        [dictionary setObject:responseDictionary[kErrorCode] forKey:kErrorCode];
        [dictionary setObject:responseDictionary[kData] forKey:kData];
    } else {
        
        switch (localErrorCode) {
            case kParameterError:
                [dictionary setObject:@"4" forKey:kErrorCode];
                [dictionary setObject:@"{}" forKey:kData];
                break;
                
            case kHttpError:
                [dictionary setObject:@"9" forKey:kErrorCode];
                [dictionary setObject:@"{}" forKey:kData];
                break;
                
            default:
                break;
        }
    }
    
    return [dictionary JSONString];
}

/**
 *  Creates and returns a security policy.
 *
 *  @return A new security policy.
 */
- (AFSecurityPolicy *)customSecurityPolicy {
    
    // certificate data
    NSData *certData = [NSData dataWithContentsOfFile:self.certificatePath];
    
    // Creates a security policy with the specified pinning mode.
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    // trust servers with an invalid or expired SSL certificates.
    securityPolicy.allowInvalidCertificates = YES;
    // not to validate the domain name in the certificate's CN field.
    securityPolicy.validatesDomainName = NO;
    // certificates content
    securityPolicy.pinnedCertificates = [NSArray arrayWithObjects:certData, nil];
    
    return securityPolicy;
}

// host URL
+ (NSString *)hostURL {

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSDictionary *autoLinQDictionary = [infoDictionary objectForKey:kAutoLinQ];
    NSString *hostURL = autoLinQDictionary[kHostURL];

    return hostURL;
}

@end
