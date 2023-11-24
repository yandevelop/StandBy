#import "StandByView.h"
#import "../GradientView/GradientView.m"

@implementation StandByView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor blackColor];

        ColorPalette *palette = [[ColorPalette alloc] init];
        GradientView *gradientView = [[GradientView alloc] initWithFrame:self.frame colors:[palette lightToDarkPalette]];
        gradientView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:gradientView];

        [NSLayoutConstraint activateConstraints:@[
            [gradientView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [gradientView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [gradientView.widthAnchor constraintEqualToAnchor:self.widthAnchor],
            [gradientView.heightAnchor constraintEqualToAnchor:self.heightAnchor]
        ]];

        
        self.viewsArray = [NSMutableArray array];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapGesture.numberOfTapsRequired = 3; // Require three taps
        [self addGestureRecognizer:tapGesture];

        
        // Slideshow
        NSArray<UIImage *> *imageArray = @[
            [UIImage imageWithContentsOfFile:@"/User/Media/DCIM/100APPLE/IMG_0288.JPG"],
            [UIImage imageWithContentsOfFile:@"/User/Media/DCIM/100APPLE/IMG_0496.JPG"],
            [UIImage imageWithContentsOfFile:@"/User/Media/DCIM/100APPLE/IMG_0497.JPG"]
        ];
        
        self.slideshowView = [[SlideshowView alloc] initWithFrame:self.frame];
        self.slideshowView.images = imageArray;
        [self addSubview:self.slideshowView];

        [self.viewsArray addObject:self.slideshowView];

        [NSLayoutConstraint activateConstraints:@[
            [self.slideshowView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [self.slideshowView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [self.slideshowView.widthAnchor constraintEqualToAnchor:self.heightAnchor],
            [self.slideshowView.heightAnchor constraintEqualToAnchor:self.widthAnchor]
        ]];
        /*

        // MomentView
        self.momentView = [[MomentView alloc] initWithFrame:self.bounds];
        self.momentView.alpha = 0.0;
        [self addSubview:self.momentView];

        [self.viewsArray addObject:self.momentView];

        [NSLayoutConstraint activateConstraints:@[
            [self.momentView.widthAnchor constraintEqualToAnchor:self.widthAnchor],
            [self.momentView.heightAnchor constraintEqualToAnchor:self.heightAnchor],
            [self.momentView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [self.momentView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
        ]];

        // DualView
        self.dualView = [[DualView alloc] initWithFrame:self.bounds];
        self.dualView.alpha = 0.0;
        [self addSubview:self.dualView];

        [self.viewsArray addObject:self.dualView];

        [NSLayoutConstraint activateConstraints:@[
            [self.dualView.widthAnchor constraintEqualToAnchor:self.widthAnchor],
            [self.dualView.heightAnchor constraintEqualToAnchor:self.heightAnchor],
            [self.dualView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [self.dualView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
        ]];

        // MusicView
        self.musicView = [[MusicView alloc] initWithFrame:self.bounds];
        self.musicView.alpha = 0.0;
        [self addSubview:self.musicView];

        [self.viewsArray addObject:self.musicView];

        [NSLayoutConstraint activateConstraints:@[
            [self.musicView.widthAnchor constraintEqualToAnchor:self.widthAnchor],
            [self.musicView.heightAnchor constraintEqualToAnchor:self.heightAnchor],
            [self.musicView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [self.musicView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
        ]];

        self.currentViewIndex = 0;

        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeViews)];
        [swipeGesture setDirection:UISwipeGestureRecognizerDirectionDown];
        swipeGesture.delegate = self;
        [self addGestureRecognizer:swipeGesture];*/
    }
    return self;
}

- (void)changeViews {
    CGFloat viewHeight = self.bounds.size.height;

    UIView *currentView = self.viewsArray[self.currentViewIndex];
    self.currentViewIndex = (self.currentViewIndex + 1) % self.viewsArray.count;
    UIView *nextView = self.viewsArray[self.currentViewIndex];

    // Set the initial frame of 'fromView' to be off-screen at the bottom
    CGRect fromViewInitialFrame = CGRectMake(0, viewHeight, currentView.frame.size.width, currentView.frame.size.height);
    currentView.frame = fromViewInitialFrame;

    // Set the initial frame of 'toView' to be off-screen at the top
    CGRect toViewInitialFrame = CGRectMake(0, -viewHeight, nextView.frame.size.width, nextView.frame.size.height);
    nextView.frame = toViewInitialFrame;

    if ([currentView isKindOfClass:[SlideshowView class]]) {
        [self.slideshowView stopSlideshow];
    } else if ([nextView isKindOfClass:[SlideshowView class]]){
        [self.slideshowView setupTimer];
    }

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
        // Perform the transition and disappearance action here
        [UIView animateWithDuration:0.5 animations:^{
            // Animate the view out of the screen, or set its alpha to 0, or remove it from the view hierarchy
            self.alpha = 0.0;
        } completion:nil];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
}

- (BOOL)isDeviceCharging {
    UIDevice *device = [UIDevice currentDevice];
    return device.batteryState == UIDeviceBatteryStateCharging || device.batteryState == UIDeviceBatteryStateFull;
}
@end
