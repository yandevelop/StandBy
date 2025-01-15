#import "Tweak.h"
#define NSLog(args...) NSLog(@"[StandBy] " args);

%hook CSProudLockViewController
%property (nonatomic, strong) StandByViewController *SBViewController;

- (void)viewDidLoad {
   %orig;

   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (BOOL)shouldAutorotate {
	return YES;
}

%new
- (void)deviceOrientationDidChange:(NSNotification *)notification {
	UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
	if (!self.SBViewController) {
		self.SBViewController = [[StandByViewController alloc] init];
		self.SBViewController.modalPresentationStyle = UIModalPresentationFullScreen;
	}
	
	if (orientation == UIDeviceOrientationLandscapeLeft) {
		//[[objc_getClass("SBLockScreenManager") sharedInstance] setBiometricAutoUnlockingDisabled:YES forReason:@"com.yan.standby"];
    	//[[objc_getClass("SBUIBiometricResource") sharedInstance] noteScreenDidTurnOff];
		[self presentViewController:self.SBViewController animated:YES completion:nil];
		// put viewcontroller on topo
		[self.view bringSubviewToFront:self.SBViewController.view];
		self.SBViewController.view.alpha = 1.0;
	} else if (orientation == UIDeviceOrientationLandscapeRight) {
		//[self presentViewController:self.SBViewController animated:YES completion:nil];
		self.SBViewController.view.alpha = 1.0;
	} else if (orientation == UIDeviceOrientationPortrait) {
		self.SBViewController.view.alpha = 0.0;
		[self.SBViewController dismissViewControllerAnimated:YES completion:nil];
	}
}
%end

%hook SBMediaController
- (void)setNowPlayingInfo:(id)arg1 {
	%orig;

	[[NSNotificationCenter defaultCenter] postNotificationName:@"MusicChanged" object:nil userInfo:@{@"isPlaying" : @([self isPlaying])}];
}
%end