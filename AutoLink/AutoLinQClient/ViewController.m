//
//  ViewController.m
//  AutoLinQ
//
//  Created by WangErdong on 16/4/9.
//
//

#import "ViewController.h"
#import "QiniuUtil.h"
#import "Payload.h"
#import "HttpClient.h"
#import "Des.h"
#import "ZipUtil.h"
#import "JSONKit.h"

#import "ProtoBufManager.h"

#define kServer  @"http://123.56.102.92:80/server/rest/gateway/root"
#define kServer2 @"http://123.56.102.92:80/server/rest/gateway/protobuffer/common"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *pkgNumUITextField;
@property (weak, nonatomic) IBOutlet UISwitch *isEncryptionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *isCompressSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *isProtocolBufferSwitch;
@property (weak, nonatomic) IBOutlet UIButton *logonButton;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

- (IBAction)doLogon:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 点击屏幕任何地方,收起键盘
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponder:)]];
    
    _logonButton.layer.cornerRadius = 5;
    
    // 初始赋值
    _usernameTextField.text = @"JohnMac";
    
    _passwordTextField.text = @"1234qwer";
    
    _pkgNumUITextField.text = @"1";
    _pkgNumUITextField.keyboardType = UIKeyboardTypeNumberPad;
    
    _isEncryptionSwitch.on = YES;
    
    _isCompressSwitch.on = YES;
    
    _isProtocolBufferSwitch.on = YES;
}

- (IBAction)doLogon:(UIButton *)sender {
    
    _tipLabel.text = @"";
    
    NSString *username = [_usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *pkgNum = [_pkgNumUITextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *isEncryption = _isEncryptionSwitch.on?@"1":@"0";
    NSString *isCompress = _isCompressSwitch.on?@"1":@"0";
    BOOL isProtocolBuffer = _isProtocolBufferSwitch.on;
    
    if (username.length == 0 || password.length ==0 || [pkgNum integerValue]<=0) {
        _tipLabel.textColor = [UIColor redColor];
        _tipLabel.text = @"用户名、密码不能为空！分包数必需大于1！";
        return;
    }
    
    NSString *data = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}", username, password];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@"Logon" forKey:kFuncID];
    [dict setObject:pkgNum forKey:kPkgNum];
    [dict setObject:isEncryption forKey:kIsEncryption];
    [dict setObject:isCompress forKey:kIsCompress];
    [dict setObject:data forKey:kData];
    
    if (!isProtocolBuffer) {
        
        [HttpClient POST:kServer parameters:dict finish:^(id responseObject) {
            _tipLabel.text = [responseObject description];
            NSLog(@"responseObject=%@", responseObject);
        }];
    } else {
        
        // generate commom message
        NSString *payLoadJson = [Payload generateCommomMsgWithFunid:@"Logon" pkgNum:pkgNum isEncryption:isEncryption isCompress:isCompress data:data];
        // commom message to dictionary
        NSDictionary *payLoadDict = [payLoadJson objectFromJSONString];
        //        // post data
        //        NSData *data = [ProtoBufManager dictionaryToData:payLoadDict];
        
        
        
        
        NSInteger iPkgNum = [pkgNum intValue];
        
        // for package
        NSString *allData = payLoadDict[kData];
        NSUInteger pkgLength = allData.length/iPkgNum;
        
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
        [self post:parametersArray];
        
        
        
        
        //        NSString *urlString = [kServer2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //        NSURL *url = [NSURL URLWithString:urlString];
        //
        //        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
        //        [request setHTTPMethod:@"POST"];
        //        [request setHTTPBody:data];
        //
        //        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //            if (connectionError) {
        //                dispatch_async(dispatch_get_main_queue(), ^{
        //                    _tipLabel.text = [connectionError description];
        //                });
        //            } else {
        //                NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //                NSDictionary *responseDictionary = [result objectFromJSONString];
        //                NSLog(@"response:%@", responseDictionary);
        //                dispatch_async(dispatch_get_main_queue(), ^{
        //                    _tipLabel.text = [responseDictionary description];
        //                });
        //            }
        //        }];
    }
}

- (void)post:(NSArray *)parameters {
    
    
    // http parameters Array
    NSMutableArray *array = [NSMutableArray arrayWithArray:parameters];
    
    NSDictionary *parametersDictionary = (NSDictionary *)[array firstObject];
    NSLog(@"parameters:%@", parametersDictionary);
    
    
    // post data
    NSData *data = [ProtoBufManager dictionaryToData:parametersDictionary];
    
    NSString *urlString = [kServer2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _tipLabel.text = [connectionError description];
            });
        } else {
            NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *responseDictionary = [result objectFromJSONString];
            NSLog(@"response:%@", responseDictionary);
            
            
            
            
            
            // http success
            if ([responseDictionary[kErrorCode] intValue] == 0) {
                
                NSDictionary *dataDictionary = (NSDictionary *)responseDictionary[kData];
                if ([dataDictionary allKeys].count > 0) { // all request end
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _tipLabel.text = [responseDictionary description];
                    });
                } else {
                    
                    // not all request end
                    [array removeObjectAtIndex:0];
                    [self post:array];
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _tipLabel.text = [responseDictionary description];
                });
            }
            
            
            
            
            
        }
    }];
    
}

// 点击屏幕任何地方,收起键盘
- (void)resignFirstResponder:(UIGestureRecognizer *)recognizer {
    
    [self.view endEditing:YES];
}

@end
