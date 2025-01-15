#import "GradientView.h"

@implementation GradientView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }

    return self;
}

- (void)setColors:(NSArray<UIColor *> *)colors {
    self.gradientColors = colors;
    self.currentColorIndex = 0;
    [self setupGradientLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.gradientLayer.frame = self.bounds;
}

- (void)setupGradientLayer {
    self.gradientLayer = [CAGradientLayer layer];
    [self.layer addSublayer:self.gradientLayer];

    self.gradientLayer.colors = @[(id)self.gradientColors[self.currentColorIndex].CGColor,
                                (id)self.gradientColors[(self.currentColorIndex + 1) % self.gradientColors.count].CGColor];
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
