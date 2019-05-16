#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

#import <Flutter/Flutter.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
  FlutterMethodChannel* batteryChannel = [FlutterMethodChannel methodChannelWithName: @"content-shop.com/battery" binaryMessenger: controller];
  [batteryChannel setMethodCallHandler: ^(FlutterMethodCall* call, FlutterResult result){
    if([@"getBatteryLevel" isEqualToString:call.method]){
      int batteryLevel=[self getBatteryLevel];

      if(batteryLevel==-1){
        result([FlutterError errorWithCode:@"无法获取" message:@"无法获取信息" details:nil]);
      }else{
        result(@(batteryLevel));
      }
    }else{
      result(FlutterMethodNotImplemented);
    }
  }];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

-(int)getBatteryLevel{
  UIDevice* device = UIDevice.currentDevice;
  device.batteryMonitoringEnabled = YES;
  if(device.batteryState == UIDeviceBatteryStateUnknown){
    return -1;
  }else{
    return (int)(device.batteryLevel*100);
  }
}

@end
