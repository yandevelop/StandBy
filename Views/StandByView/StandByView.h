#import <QuartzCore/QuartzCore.h>
#import "../../Core/TimeManager/TimeManager.m"
#import "../../Core/WeatherManager/WeatherManager.m"
#import "../MomentView/MomentView.m"
#import "../SlideshowView/SlideshowView.m"
#import "../DualView/DualView.m"
#import "../../Core/ColorPalette.m"
#import "../MusicView/MusicView.m"

@interface StandByView : UIView <UIGestureRecognizerDelegate>
@property (nonatomic, assign) NSInteger currentColorIndex;
@property (nonatomic, strong) DualView *dualView;
@property (nonatomic, strong) MomentView *momentView;
@property (nonatomic, strong) SlideshowView *slideshowView;
@property (nonatomic, strong) MusicView *musicView;
@property (nonatomic, strong) NSMutableArray<UIView *> *viewsArray;
@property (nonatomic, assign) NSInteger currentViewIndex;
- (BOOL)isDeviceCharging;

@end