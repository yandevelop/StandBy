#import "DualView.h"

@implementation DualView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        [[WeatherManager sharedInstance] refreshWeatherData];

        self.timeContainerView = [[UIView alloc] init];
        self.timeContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.timeContainerView];

        self.timeStackView = [[UIStackView alloc] init];
        self.timeStackView.axis = UILayoutConstraintAxisVertical;
        self.timeStackView.distribution = UIStackViewDistributionEqualSpacing;
        self.timeStackView.alignment = UIStackViewAlignmentCenter;
        self.timeStackView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.timeContainerView addSubview:self.timeStackView];

        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.textColor = [[PrefsManager sharedInstance] colorForKey:@"SBFontColor"];
        self.dateLabel.font = [UIFont boldSystemFontOfSize:50];
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.dateLabel.text = [[TimeManager sharedInstance] currentDateWithFormat:@"E MMM"];
        [self.timeStackView addArrangedSubview:self.dateLabel];

        self.dayLabel = [[UILabel alloc] init];
        self.dayLabel.textColor = [UIColor whiteColor];
        self.dayLabel.font = [UIFont boldSystemFontOfSize:200];
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.dayLabel.text = [[TimeManager sharedInstance] currentDateWithFormat:@"dd"];
        [self.timeStackView addArrangedSubview:self.dayLabel];

        [NSLayoutConstraint activateConstraints:@[
            [self.timeContainerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [self.timeContainerView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.5],
            [self.timeContainerView.heightAnchor constraintEqualToAnchor:self.heightAnchor],

            [self.timeStackView.centerXAnchor constraintEqualToAnchor:self.timeContainerView.centerXAnchor],
            [self.timeStackView.centerYAnchor constraintEqualToAnchor:self.timeContainerView.centerYAnchor],
        ]];


        self.weatherContainerView = [[UIView alloc] init];
        self.weatherContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.weatherContainerView];

        self.locationLabel = [[UILabel alloc] init];
        self.locationLabel.textColor = [UIColor whiteColor];
        self.locationLabel.font = [UIFont boldSystemFontOfSize:32];
        self.locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.locationLabel.text = [[WeatherManager sharedInstance] currentLocation];
        [self.weatherContainerView addSubview:self.locationLabel];

        self.temperatureLabel = [[UILabel alloc] init];
        self.temperatureLabel.textColor = [UIColor whiteColor];
        self.temperatureLabel.font = [UIFont boldSystemFontOfSize:130];
        self.temperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.temperatureLabel.text = [[WeatherManager sharedInstance] currentTemperature];
        [self.weatherContainerView addSubview:self.temperatureLabel];

        self.conditionEmoji = [[UILabel alloc] init];
        self.conditionEmoji.font = [UIFont boldSystemFontOfSize:40];
        self.conditionEmoji.translatesAutoresizingMaskIntoConstraints = NO;
        self.conditionEmoji.text = [[WeatherManager sharedInstance] conditionEmoji];
        [self.weatherContainerView addSubview:self.conditionEmoji];

        self.conditionLabel = [[UILabel alloc] init];
        self.conditionLabel.textColor = [UIColor whiteColor];
        self.conditionLabel.font = [UIFont boldSystemFontOfSize:32];
        self.conditionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.conditionLabel.text = [[WeatherManager sharedInstance] currentConditions];
        [self.weatherContainerView addSubview:self.conditionLabel];
    
        [NSLayoutConstraint activateConstraints:@[
            [self.weatherContainerView.leadingAnchor constraintEqualToAnchor:self.timeContainerView.trailingAnchor],
            [self.weatherContainerView.heightAnchor constraintEqualToAnchor:self.heightAnchor],
            [self.weatherContainerView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.5],

            [self.locationLabel.leadingAnchor constraintEqualToAnchor:self.weatherContainerView.leadingAnchor],
            [self.locationLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:20],

            [self.temperatureLabel.leadingAnchor constraintEqualToAnchor:self.weatherContainerView.leadingAnchor],
            [self.temperatureLabel.topAnchor constraintEqualToAnchor:self.locationLabel.bottomAnchor constant:-10],

            [self.conditionLabel.leadingAnchor constraintEqualToAnchor:self.weatherContainerView.leadingAnchor],
            [self.conditionLabel.bottomAnchor constraintEqualToAnchor:self.weatherContainerView.bottomAnchor constant:-60],

            [self.conditionEmoji.leadingAnchor constraintEqualToAnchor:self.weatherContainerView.leadingAnchor],
            [self.conditionEmoji.bottomAnchor constraintEqualToAnchor:self.conditionLabel.topAnchor]
        ]];

    }
    return self;
}

@end