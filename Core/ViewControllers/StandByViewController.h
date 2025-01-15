#import "../Managers/Managers.h"
#import "../Views/Views.h"
#import "../Palette/ColorPalette.m"

@interface StandByViewController : UIViewController <UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray<UIView *> *viewsArray;
@property (nonatomic, strong) GradientView *gradientView;
@property (nonatomic, strong) MomentView *momentView;
@property (nonatomic, strong) DualView *dualView;
@property (nonatomic, strong) MusicView *musicView;
@property (nonatomic, assign) NSInteger currentViewIndex;
@end