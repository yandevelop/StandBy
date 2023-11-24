
#import <GcUniversal/GcColorPickerUtils.h>

@interface PrefsManager : NSObject
+ (instancetype)sharedInstance;
- (UIColor *)colorForKey:(NSString *)key;
- (id)settingForKey:(NSString *)key withIdentifier:(NSString *)identifier;
@end


@implementation PrefsManager
+ (instancetype)sharedInstance {
    static PrefsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PrefsManager alloc] init];
    });
    return sharedInstance;
}

- (UIColor *)colorForKey:(NSString *)key {
    return [GcColorPickerUtils colorFromDefaults:@"com.yan.standbypreferences" withKey:key fallback:@"ffffff"];
}
@end