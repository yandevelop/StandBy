@interface MomentView : UIView
@property (nonatomic, retain) UILabel *clockLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, retain) UILabel *conditionLabel;
@property (nonatomic, retain) UIView *descriptionView;
@property (nonatomic, retain) NSTimer *timer;
- (void)updateClock;
- (void)updateConstraints;
@end