#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Core/ViewControllers/StandByViewController.m"

@interface CSProudLockViewController : UIViewController
@property (nonatomic, strong) StandByViewController *SBViewController;
- (void)deviceOrientationDidChange:(NSNotification *)notification;
@end

@interface SBLockScreenManager : NSObject
+ (id)sharedInstance;
- (void)setBiometricAutoUnlockingDisabled:(BOOL)disabled forReason:(NSString *)reason;
@end

@interface SBUIBiometricResource : NSObject
+ (id)sharedInstance;
- (void)noteScreenDidTurnOff;
- (void)noteScreenWillTurnOn;
@end