@interface DualView : UIView
@property (nonatomic, strong) UIView *timeContainerView;
@property (nonatomic, strong) UIStackView *timeStackView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UIView *weatherContainerView;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *temperatureLabel;
@property (nonatomic, strong) UILabel *conditionEmoji;
@property (nonatomic, strong) UILabel *conditionLabel;
@end
