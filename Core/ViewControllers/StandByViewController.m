#import "StandByViewController.h"

@implementation StandByViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor blueColor];
    self.viewsArray = [NSMutableArray array];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.numberOfTapsRequired = 3; // Require three taps
    [self.view addGestureRecognizer:tapGesture];

    [self addGradientView];

    //[self addMomentView];

    [self addDualView];

    //[self addMusicView];

    [self addSwipeGestureRecognizer];
}

- (void)addSwipeGestureRecognizer {
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeViews)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionDown];
    swipeGesture.delegate = self;
    [self.view addGestureRecognizer:swipeGesture];
}

- (void)addMusicView {
    self.musicView = [MusicView new];
    self.musicView.alpha = 1.0;
    [self.view addSubview:self.musicView];

    [self.viewsArray addObject:self.musicView];

    [NSLayoutConstraint activateConstraints:@[
        [self.musicView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
        [self.musicView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor],
        [self.musicView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.musicView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
}

- (void)addDualView {
    self.dualView = [DualView new];
    self.dualView.alpha = 1.0;
    [self.view addSubview:self.dualView];

    [self.viewsArray addObject:self.dualView];

    [NSLayoutConstraint activateConstraints:@[
        [self.dualView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
        [self.dualView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor],
        [self.dualView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.dualView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
}

- (void)addMomentView {
    self.momentView = [MomentView new];
    self.momentView.alpha = 1.0;
    [self.view addSubview:self.momentView];

    [NSLayoutConstraint activateConstraints:@[
        [self.momentView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
        [self.momentView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor],
        [self.momentView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.momentView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
    [self.viewsArray addObject:self.momentView];
}

- (void)addGradientView {
    ColorPalette *palette = [ColorPalette new];
    self.gradientView = [GradientView new];
    // device bounds
    self.gradientView.frame = self.view.bounds;
    [self.gradientView setColors:[palette lightToDarkPalette]];
    [self.view addSubview:self.gradientView];

    [NSLayoutConstraint activateConstraints:@[
        [self.gradientView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.gradientView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.gradientView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.gradientView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];

    [self.viewsArray addObject:self.gradientView];
}

- (void)changeViews {
    CGFloat viewHeight = self.view.bounds.size.height;

    UIView *currentView = self.viewsArray[self.currentViewIndex];
    self.currentViewIndex = (self.currentViewIndex + 1) % self.viewsArray.count;
    UIView *nextView = self.viewsArray[self.currentViewIndex];

    // Set the initial frame of 'fromView' to be off-screen at the bottom
    CGRect fromViewInitialFrame = CGRectMake(0, viewHeight, currentView.frame.size.width, currentView.frame.size.height);
    currentView.frame = fromViewInitialFrame;

    // Set the initial frame of 'toView' to be off-screen at the top
    CGRect toViewInitialFrame = CGRectMake(0, -viewHeight, nextView.frame.size.width, nextView.frame.size.height);
    nextView.frame = toViewInitialFrame;

    /*if ([currentView isKindOfClass:[SlideshowView class]]) {
        [self.slideshowView stopSlideshow];
    } else if ([nextView isKindOfClass:[SlideshowView class]]){
        [self.slideshowView setupTimer];
    }*/

    currentView.alpha = 0.0;

    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:1.0  // Adjust the damping to control bounce effect
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // Animate the views' frames to create a sliding effect
                         currentView.frame = CGRectOffset(fromViewInitialFrame, 0, -viewHeight);
                         nextView.frame = CGRectOffset(toViewInitialFrame, 0, viewHeight);


                         nextView.alpha = 1.0;
                     }
        completion:nil];
}

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        [UIView animateWithDuration:0.5 animations:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        } completion:nil];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)_canShowWhileLocked {
    return true;
}
@end