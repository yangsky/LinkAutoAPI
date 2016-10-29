//
//  Authorization.m
//  AutoLinQ
//
//  Created by steven_yang on 16/3/20.
//
//

#define BASEURL @"http://beta-service.kalay.us:9900" //test url


#import "Authorization.h"

@implementation Authorization


// MARK: getter userEmail or userPassword
-(NSString *)userEmail
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"USEREMAIL"];
}
-(NSString *)userPassword
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"USERPW"];
}

// MARK:USER API Method

-(NSString *)getAuthenticationTokenWithUrl:(NSString *)baseurlString;
{
    NSString *urlString = [NSString stringWithFormat:@"%@/token-auth/",baseurlString];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSDictionary *params = @{@"email": self.userEmail, @"password": self.userPassword};
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[self httpBodyForParamsDictionary:params]];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    NSString *token;
    if (responseData != nil) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&requestError];
        
        token = json[@"token"];
        if (token) {
            NSLog(@"get token success ! %@",token);
        }
    }
    return token;
}

// MARK: http helper method

- (NSData *)httpBodyForParamsDictionary:(NSDictionary *)paramDictionary
{
    NSMutableArray *parameterArray = [NSMutableArray array];
    
    [paramDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        NSString *param = [NSString stringWithFormat:@"%@=%@", key, [self percentEscapeString:obj]];
        [parameterArray addObject:param];
    }];
    
    NSString *string = [parameterArray componentsJoinedByString:@"&"];
    
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)percentEscapeString:(NSString *)string
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}


@end
