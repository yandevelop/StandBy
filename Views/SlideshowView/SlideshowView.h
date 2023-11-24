@interface SlideshowView : UIView
@property (nonatomic, strong) NSArray<UIImage *> *images;
@property (nonatomic, strong) UILabel *clockLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSTimer *timer;
- (void)startSlideshow;
- (void)stopSlideshow;
- (void)updateConstraints;
@end