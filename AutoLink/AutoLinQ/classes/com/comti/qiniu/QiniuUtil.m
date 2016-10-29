//
//  QiniuUtil.m
//  AutoLinQ
//
//  Created by WangErdong on 16/4/10.
//
//

#import "QiniuUtil.h"
#import "QiniuSDK.h"
#import "QNUrlSafeBase64.h"
#import "Hmac.h"

#define kAccessKey @"472jehVqzM6ug9DT_MX6jIXitXWruC6mFlcp9IXS"
#define kSecretKey @"v9rM1s-EtvEG3gnC00myMxN9QGxvTcm57P2ZDZjd"

@implementation QiniuUtil

+ (void)upload {

    NSData *imageData = [@"Hello, World!" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *key = @"Hello";
    NSString *token = [self uploadToken];
    QNUploadOption *option = nil;

    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:imageData key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"%@", info);
        NSLog(@"%@", resp);
    } option:option];
}

// 上传凭证 http://developer.qiniu.com/article/developer/security/upload-token.html
+ (NSString *)uploadToken {
    
    NSString *uploadToken = nil;

    // 构造上传策略
    

    // 将上传策略序列化成为JSON格式
    NSString *putPolicy = @"{\"scope\":\"shaodong:Hello\", \"deadline\":1462032000}";

    // 对JSON编码的上传策略进行URL安全的Base64编码
    NSString *encodedPutPolicy = [QNUrlSafeBase64 encodeString:putPolicy];

    // 使用SecretKey对上一步生成的待签名字符串计算HMAC-SHA1签名
    NSString *sign = [Hmac encrypt2HMAC:encodedPutPolicy key:kSecretKey];

    // 对签名进行URL安全的Base64编码
//    NSString *encodedSign = [QNUrlSafeBase64 encodeString:sign];

    // 将AccessKey、encodedSign和encodedPutPolicy用:连接起来
    uploadToken = [NSString stringWithFormat:@"%@:%@:%@", kAccessKey, sign, encodedPutPolicy];

    NSLog(@"token:%@", uploadToken);
    return uploadToken;
}

@end
