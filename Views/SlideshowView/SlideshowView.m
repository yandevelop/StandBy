#import "SlideshowView.h"

@implementation SlideshowView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.clipsToBounds = YES;

        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.imageView];

        self.clockLabel = [[UILabel alloc] init];
        self.clockLabel.textColor = [UIColor whiteColor];
        self.clockLabel.font = [UIFont boldSystemFontOfSize:92];
        self.clockLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.clockLabel];

        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.textColor = [UIColor whiteColor];
        self.dateLabel.text = [[TimeManager sharedInstance] currentDateWithFormat:@"MMM dd, yyyy"];
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.dateLabel.font = [UIFont boldSystemFontOfSize:24];
        [self addSubview:self.dateLabel];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateClock:) name:@"TimeChanged" object:nil];

        [[TimeManager sharedInstance] startUpdating];

        [self updateConstraints];

        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipImage:)];
        recognizer.numberOfTapsRequired = 2;

        // Add the gesture recognizer to the SlideshowView
        [self addGestureRecognizer:recognizer];
    }

    return self;
}

- (void)updateImageBrightness {
    UIImage *currentImage = self.images[self.currentIndex];
    CGFloat brightness = [self calculateBrightnessForImage:currentImage];

    NSLog(@"[StandBy] %f", brightness);

    UIColor *dateLabelTextColor = (brightness < 0.5) ? [UIColor whiteColor] : [UIColor blackColor];

    if ([dateLabelTextColor isEqual:self.dateLabel.textColor]) return;

    [UIView animateWithDuration:0.2 animations:^{
        self.dateLabel.alpha = 0.0; // Fade out
        self.clockLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.dateLabel.textColor = dateLabelTextColor; // Change text color
        self.clockLabel.textColor = dateLabelTextColor;
        [UIView animateWithDuration:0.2 animations:^{
            self.dateLabel.alpha = 1.0; // Fade in
            self.clockLabel.alpha = 1.0;
        }];
    }];
}

- (CGFloat)calculateBrightnessForImage:(UIImage *)image {
    // Calculate the brightness of an image
    CGImageRef imageRef = [image CGImage];
    CGDataProviderRef provider = CGImageGetDataProvider(imageRef);
    NSData *data = (NSData *)CFBridgingRelease(CGDataProviderCopyData(provider));

    const UInt8 *bytes = [data bytes];
    double totalBrightness = 0;
    NSInteger width = image.size.width;
    NSInteger height = image.size.height;

    for (NSInteger x = 0; x < width; x++) {
        for (NSInteger y = 0; y < height; y++) {
            NSInteger pixelIndex = ((width * y) + x) * 4; // Each pixel has 4 components (RGBA)
            UInt8 red = bytes[pixelIndex];
            UInt8 green = bytes[pixelIndex + 1];
            UInt8 blue = bytes[pixelIndex + 2];
            double brightness = (0.299 * red + 0.587 * green + 0.114 * blue) / 255.0; // Calculate brightness in the range [0, 1]
            totalBrightness += brightness;
        }
    }

    return totalBrightness / (width * height);
}

- (void)skipImage:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        [self.timer invalidate];
        [self advanceSlideshow];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(advanceSlideshow) userInfo:nil repeats:YES];
    }
}

- (void)updateClock:(NSNotification *)notification {
    NSString *currentTime = notification.userInfo[@"currentTime"];
    self.clockLabel.text = currentTime;
}

- (void)updateConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.imageView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],

       // [self.imageView.widthAnchor constraintEqualToAnchor:self.imageView.heightAnchor],

        [self.clockLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-40],
        [self.clockLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:20],

        [self.dateLabel.trailingAnchor constraintEqualToAnchor:self.clockLabel.trailingAnchor],
        [self.dateLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-40]
    ]];

    [super updateConstraints];
}

- (void)setImages:(NSArray<UIImage *> *)images {
    _images = images;
    // Start the slideshow when images are set
    [self startSlideshow];
}

- (void)startSlideshow {
    if (self.images.count == 0) {
        return;
    }

    self.currentIndex = arc4random_uniform((uint32_t)self.images.count);
    
    [self updateUIWithCurrentIndex];
    
    // Configure a timer to advance the slideshow
    [self setupTimer];
}

- (void)stopSlideshow {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setupTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(advanceSlideshow) userInfo:nil repeats:YES];
}

- (void)advanceSlideshow {
    [self updateImageBrightness];
    self.currentIndex = (self.currentIndex + 1) % self.images.count;
    [self updateUIWithCurrentIndex];
}

- (void)updateUIWithCurrentIndex {
    if (self.images.count > 0) {
        [UIView transitionWithView:self.imageView duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.imageView.image = self.images[self.currentIndex];
        }
        completion:nil];

        self.currentIndex = (self.currentIndex + 1) % self.images.count;
    }
}

- (void)dealloc {
    [[TimeManager sharedInstance] stopUpdating];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end