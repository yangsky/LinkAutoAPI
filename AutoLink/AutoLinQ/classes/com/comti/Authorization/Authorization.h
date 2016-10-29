//
//  Authorization.h
//  AutoLinQ
//
//  Created by steven_yang on 16/3/20.
//
//

#import <Foundation/Foundation.h>

@interface Authorization : NSObject

@property (nonatomic,strong) NSString *userEmail;   //uesr

@property (nonatomic,strong) NSString *userPassword;    //password

/**
 *  Get user Authorization Token
 *
 *  @param baseurlString  The URL string used to create the request URL.
 *
*/
-(NSString *)getAuthenticationTokenWithUrl:(NSString *)baseurlString;

@end
