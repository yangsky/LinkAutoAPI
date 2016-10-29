//
//  MqttClient.m
//  AutoLinQ
//
//  Created by com.conti on 16/4/17.
//  Copyright (c) 2016年 com.conti. All rights reserved.
//
//
#import "MQTTClient.h"

@interface MQTTClient ()

@property (nonatomic, retain) MQTTClient *mqttClient;
@end

@implementation MQTTClient

#pragma mark - Connection

- (void) connectWithCompletionHandler:(void (^)(MQTTConnectionReturnCode code))completionHandler {
    
    [self.mqttClient connectWithCompletionHandler:completionHandler];
}
- (void) connectToHost: (NSString*)host
     completionHandler:(void (^)(MQTTConnectionReturnCode code))completionHandler {
    
    self.host = host;
    self.mqttClient.host = host;
    [self.mqttClient connectToHost:host completionHandler:completionHandler];
}
- (void) disconnectWithCompletionHandler:(void (^)(NSUInteger code))completionHandler {
    
    [self.mqttClient disconnectWithCompletionHandler:completionHandler];
}
- (void) reconnect {
    
    [self.mqttClient reconnect];
}

#pragma mark - Publish

- (void)publishString:(NSString *)payload
              toTopic:(NSString *)topic
              withQos:(MQTTQualityOfService)qos
               retain:(BOOL)retain
    completionHandler:(void (^)(int mid))completionHandler {
    
    [self.mqttClient publishString:payload toTopic:topic withQos:qos retain:retain completionHandler:completionHandler];
}

#pragma mark - Subscribe

- (void)subscribe:(NSString *)topic
          withQos:(MQTTQualityOfService)qos
completionHandler:(MQTTSubscriptionCompletionHandler)completionHandler {
    
    [self.mqttClient subscribe:topic withQos:qos completionHandler:completionHandler];
}
- (void)unsubscribe: (NSString *)topic
withCompletionHandler:(void (^)(void))completionHandler {
    
    [self.mqttClient unsubscribe:topic withCompletionHandler:completionHandler];
}

#pragma mark - getter
- (MQTTClient *)mqttClient {
    
    if (!_mqttClient) {
        _mqttClient = [[MQTTClient alloc] init];
        
        _mqttClient.clientID = self.clientID;
        _mqttClient.host = self.host;
        _mqttClient.port = self.port;
        _mqttClient.username = self.username;
        _mqttClient.password = self.password;
        _mqttClient.keepAlive = self.keepAlive;
        _mqttClient.cleanSession = self.cleanSession;
        _mqttClient.messageHandler = self.messageHandler;
    }
    
    return _mqttClient;
}
@end
