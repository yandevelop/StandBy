#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Core/PrefsManager/PrefsManager.m"
#import "Views/StandByView/StandByView.m"
#import <Cephei/HBPreferences.h>
#import <GcUniversal/GcColorPickerUtils.h>

HBPreferences *prefs;
BOOL enabled;

@interface CSProudLockViewController : UIViewController
@property (nonatomic, strong) StandByView *standByView;
- (void)deviceOrientationDidChange:(NSNotification *)notification;
- (void)setupStandByView;
- (BOOL)isDeviceCharging;
@end
