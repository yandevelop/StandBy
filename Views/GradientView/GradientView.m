@interface GradientView : UIView

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) NSArray<UIColor *> *gradientColors;
@property (nonatomic, assign) NSUInteger currentColorIndex;

@end

@implementation GradientView

- (instancetype)initWithFrame:(CGRect)frame colors:(NSArray<UIColor *> *)colors {
    self = [super initWithFrame:frame];
    if (self) {
        self.gradientColors = colors;
        self.currentColorIndex = 0;
        [self setupGradientLayer];
    }
    return self;
}

- (void)setupGradientLayer {
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bounds;
    [self.layer addSublayer:self.gradientLayer];
    
    // Set the initial colors to the first two colors in the array
    self.gradientLayer.colors = @[(id)self.gradientColors[self.currentColorIndex].CGColor,
                                    (id)self.gradientColors[(self.currentColorIndex + 1) % self.gradientColors.count].CGColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Update the gradient layer's frame to match the view's bounds
    self.gradientLayer.frame = self.bounds;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.gradientColors.count < 2) {
        return; // Need at least two colors for animation
    }
    
    // Create a CABasicAnimation for animating the gradient
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    animation.fromValue = @[
        (id)self.gradientColors[self.currentColorIndex].CGColor,
        (id)self.gradientColors[(self.currentColorIndex + 1) % self.gradientColors.count].CGColor
    ];
    self.currentColorIndex = (self.currentColorIndex + 2) % self.gradientColors.count;
    animation.toValue = @[
        (id)self.gradientColors[self.currentColorIndex].CGColor,
        (id)self.gradientColors[(self.currentColorIndex + 1) % self.gradientColors.count].CGColor
    ];
    animation.duration = 8.0; // Duration of the animation in seconds
    animation.autoreverses = YES; // Do not reverse the animation
    animation.repeatCount = HUGE_VALF; // Repeat indefinitely
    
    [self.gradientLayer addAnimation:animation forKey:@"colorAnimation"];
}

@end
