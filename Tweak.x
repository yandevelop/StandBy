#import "Tweak.h"

#define NSLog(args...) NSLog(@"[StandBy] "args)

%hook SBMediaController
- (void)setNowPlayingInfo:(id)arg1 {
	%orig;

	[[NSNotificationCenter defaultCenter] postNotificationName:@"MusicChanged" object:nil userInfo:@{@"isPlaying" : @([self isPlaying])}];
}
%end

%hook CSProudLockViewController
%property (nonatomic, strong) StandByView *standByView;

- (void)viewDidLoad {
	%orig;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
	
	[self setupStandByView];
}

%new
- (void)setupStandByView {
	self.standByView = [[StandByView alloc] initWithFrame:self.view.frame];
	self.standByView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.standByView.alpha = 0.0;

	dispatch_async(dispatch_get_main_queue(), ^{
		[self.view addSubview:self.standByView];
	});
}

%new
- (void)deviceOrientationDidChange:(NSNotification *)notification {


	CGSize landscapeSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));

	UIWindowScene *windowScene = [UIApplication sharedApplication].connectedScenes.allObjects.firstObject;
    UIInterfaceOrientation aorientation = windowScene.interfaceOrientation;
    
    if (UIInterfaceOrientationIsLandscape(aorientation)) {
        CGFloat landscapeWidth = landscapeSize.width;
        CGFloat landscapeHeight = landscapeSize.height;
        NSLog(@"Landscape Width: %f, Landscape Height: %f", landscapeWidth, landscapeHeight);
    } else {
        // Device is not in landscape orientation
        // Handle the other orientation or use the existing width and height
    }


	//if ([self isDeviceCharging] == YES) {
		UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
		if ((orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)) {
				NSLog(@"%@", NSStringFromCGRect(self.view.frame));
			if (!self.standByView) {
				[self setupStandByView];
			}

			[self.standByView updateConstraints];
			[UIView animateWithDuration:0.3 animations:^{
				self.standByView.alpha = 1.0;
			} completion:nil];
		} else if (orientation == UIDeviceOrientationPortrait && self.standByView.alpha == 1.0) {
			[UIView animateWithDuration:0.3 animations:^{
				self.standByView.alpha = 0.0;
			} completion:nil];
		} 
	//}
}


%new
- (BOOL)isDeviceCharging {
    UIDevice *device = [UIDevice currentDevice];
    return device.batteryState == UIDeviceBatteryStateCharging || device.batteryState == UIDeviceBatteryStateFull;
}

%end

%hook UIViewController
- (BOOL)prefersHomeIndicatorAutoHidden {
	return YES;
}
%end

%ctor {
	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.yan.standbypreferences"];

	[prefs registerBool:&enabled default:YES forKey:@"SBEnabled"];
	if (!enabled) return;

	%init();
}