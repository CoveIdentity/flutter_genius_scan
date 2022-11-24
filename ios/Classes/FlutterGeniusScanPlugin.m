#import "FlutterGeniusScanPlugin.h"

#import <GSSDKCore/GSSDKCore.h>
#import <GSSDKScanFlow/GSSDKScanFlow.h>
#import <GSSDKScanFlow/GSKScanFlowResult+Dictionary.h>
#import <GSSDKScanFlow/GSKScanFlowConfiguration+Dictionary.h>

@interface FlutterGeniusScanPlugin ()

@property (nonatomic, strong) GSKScanFlow *scanner;

@end

@implementation FlutterGeniusScanPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_genius_scan"
            binaryMessenger:[registrar messenger]];
  FlutterGeniusScanPlugin* instance = [[FlutterGeniusScanPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"setLicenceKey" isEqualToString:call.method]) {
    NSError *error = nil;
    BOOL validLicence = [GSK initWithLicenseKey:call.arguments error:&error];

    if (validLicence) {
        result(nil);
    } else {
        result([FlutterError errorWithCode:@"invalid_licence"
                        message:@"License key is not valid or has expired."
                        details:nil]);
    }
  } else if ([@"scanWithConfiguration" isEqualToString:call.method]) {

    NSDictionary *scanOptions = call.arguments;

    NSError *error = nil;
    GSKScanFlowConfiguration *configuration = [GSKScanFlowConfiguration configurationWithDictionary:scanOptions error:&error];
    if (!configuration) {
        result([FlutterError errorWithCode:[NSString stringWithFormat:@"%@ error %d", error.domain, error.code]
                            message:error.localizedDescription
                            details:nil]);
        return;
    }

    self.scanner = [GSKScanFlow scanFlowWithConfiguration:configuration];

    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController* viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        [self.scanner startFromViewController:viewController onSuccess:^(GSKScanFlowResult * _Nonnull sdkResult) {
            result([sdkResult dictionary]);
        } failure:^(NSError *error) {
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%@ error %d", error.domain, error.code]
                message:error.localizedDescription
                details:nil]);
        }];
    });

  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
