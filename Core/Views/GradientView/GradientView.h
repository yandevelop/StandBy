@interface GradientView : UIView
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) NSArray<UIColor *> *gradientColors;
@property (nonatomic, assign) NSUInteger currentColorIndex;

@property (nonatomic, strong) NSTimer *animationTimer;
@end