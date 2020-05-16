#import "CyberpayflutterPlugin.h"
#if __has_include(<cyberpayflutter/cyberpayflutter-Swift.h>)
#import <cyberpayflutter/cyberpayflutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "cyberpayflutter-Swift.h"
#endif

@implementation CyberpayflutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCyberpayflutterPlugin registerWithRegistrar:registrar];
}
@end
