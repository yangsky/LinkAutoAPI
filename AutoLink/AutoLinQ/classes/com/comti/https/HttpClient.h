//
//  HttpClient.h
//  AutoLinQ
//
//  Created by mac on 16/3/14.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Const.h"

typedef void (^ResponseHandler)(NSURLSessionDataTask *, id);
typedef void (^FailureHandler)(NSURLSessionDataTask *, NSError *);

@interface HttpClient : NSObject

// certificate file's path
@property (nonatomic, strong) NSString *certificatePath;

/**
 *  Creates and runs an `NSURLSessionDataTask` with a `POST` request.
 *
 *  @param URLString       The URL string used to create the request URL.
 *  @param headers         headers
 *  @param parameters      The parameters to be encoded according to the client request serializer.
 *  @param contentType     contentType
 *  @param responseHandler A block object to be executed when the task finishes successfully. 
                           This block has no return value and takes two arguments: the data task, 
                           and the response object created by the client response serializer.
 *  @param failureHandler  A block object to be executed when the task finishes unsuccessfully, 
                           or that finishes successfully, but encountered an error while parsing the response data. 
                           This block has no return value and takes a two arguments: 
                           the data task and the error describing the network or parsing error that occurred.
 */
- (void)post:(NSString *)urlString header:(NSDictionary *)headers parameters:(NSDictionary *)parameters contentType:(NSString *)contentType responseHandler:(ResponseHandler)responseHandler failure:(FailureHandler)failureHandler;

+ (void)POST:(NSString *)URLString parameters:(id)parameters finish:(void (^)(id responseObject))finish;

@end
