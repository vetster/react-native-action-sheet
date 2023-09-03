#import <React/RCTBridgeModule.h>
#import <React/RCTLog.h>

@interface RCT_EXTERN_MODULE(ReactNativeActionSheet, NSObject)

RCT_EXTERN_METHOD(showActionSheetWithOptions:(NSDictionary *)options callback:(RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(dismissActionSheet)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
