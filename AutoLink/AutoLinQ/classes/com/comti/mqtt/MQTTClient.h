//
//  MqttClient.h
//  AutoLinQ
//
//  Created by com.conti on 16/4/17.
//  Copyright (c) 2016年 com.conti. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MQTTKit.h"

typedef enum MQTTConnectionReturnCode : NSUInteger {
    ConnectionAccepted,
    ConnectionRefusedUnacceptableProtocolVersion,
    ConnectionRefusedIdentiferRejected,
    ConnectionRefusedServerUnavailable,
    ConnectionRefusedBadUserNameOrPassword,
    ConnectionRefusedNotAuthorized
} MQTTConnectionReturnCode;

typedef enum MQTTQualityOfService : NSUInteger {
    AtMostOnce,
    AtLeastOnce,
    ExactlyOnce
} MQTTQualityOfService;
#pragma mark - MQTT Message

@interface MQTTMessage : NSObject

@property (readonly, assign) unsigned short mid;
@property (readonly, copy) NSString *topic;
@property (readonly, copy) NSData *payload;
@property (readonly, assign) BOOL retained;

- (NSString *)payloadString;

@end

typedef void (^MQTTSubscriptionCompletionHandler)(NSArray *grantedQos);
typedef void (^MQTTMessageHandler)(MQTTMessage *message);

#pragma mark - MQTT Client

@class MQTTClient;

@interface MQTTClient : NSObject
{
    struct mosquitto *mosq;
}

@property (readwrite, copy) NSString *clientID;
@property (readwrite, copy) NSString *host;
@property (readwrite, assign) unsigned short port;
@property (readwrite, copy) NSString *username;
@property (readwrite, copy) NSString *password;
@property (readwrite, assign) unsigned short keepAlive;
@property (readwrite, assign) BOOL cleanSession;
@property (nonatomic, copy) MQTTMessageHandler messageHandler;

#pragma mark - Connection

- (void) connectWithCompletionHandler:(void (^)(MQTTConnectionReturnCode code))completionHandler;
- (void) connectToHost: (NSString*)host
     completionHandler:(void (^)(MQTTConnectionReturnCode code))completionHandler;
- (void) disconnectWithCompletionHandler:(void (^)(NSUInteger code))completionHandler;
- (void) reconnect;

#pragma mark - Publish

- (void)publishString:(NSString *)payload
              toTopic:(NSString *)topic
              withQos:(MQTTQualityOfService)qos
               retain:(BOOL)retain
    completionHandler:(void (^)(int mid))completionHandler;

#pragma mark - Subscribe

- (void)subscribe:(NSString *)topic
          withQos:(MQTTQualityOfService)qos
completionHandler:(MQTTSubscriptionCompletionHandler)completionHandler;
- (void)unsubscribe: (NSString *)topic
withCompletionHandler:(void (^)(void))completionHandler;

@end
