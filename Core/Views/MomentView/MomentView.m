#import "MomentView.h"

@implementation MomentView
- (instancetype)init {
    self = [super init];

    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        self.clockLabel = [UILabel new];
        self.clockLabel.font = [UIFont systemFontOfSize:180];
        self.clockLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.clockLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.clockLabel];

        self.descriptionView = [UIView new];
        self.descriptionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.descriptionView];

        self.dateLabel = [UILabel new];
        self.dateLabel.font = [UIFont boldSystemFontOfSize:24];
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.dateLabel.textColor = [UIColor whiteColor];
        [self.descriptionView addSubview:self.dateLabel];

        [[WeatherManager sharedInstance] refreshWeatherData];
        self.conditionLabel = [UILabel new];
        self.conditionLabel.font = [UIFont systemFontOfSize:24];
        self.conditionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.conditionLabel.textColor = [UIColor whiteColor];
        [self.descriptionView addSubview:self.conditionLabel];

        self.locationLabel = [UILabel new];
        self.locationLabel.font = [UIFont boldSystemFontOfSize:24];
        self.locationLabel.textColor = [UIColor whiteColor];
        self.locationLabel.text = [[WeatherManager sharedInstance] currentLocation];
        self.locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.descriptionView addSubview:self.locationLabel];

        self.conditionLabel.text = [[WeatherManager sharedInstance] conditionEmoji];

        self.dateLabel.text = [[TimeManager sharedInstance] currentDateWithFormat:@"EEE d"];

        [self updateConstraints];

        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateClock) userInfo:nil repeats:YES];
        [self updateClock];
    }
    return self;
}

- (void)updateConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.clockLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.clockLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:-20],

        [self.descriptionView.leadingAnchor constraintEqualToAnchor:self.clockLabel.leadingAnchor],
        [self.descriptionView.bottomAnchor constraintEqualToAnchor:self.clockLabel.bottomAnchor],
        [self.descriptionView.widthAnchor constraintEqualToAnchor:self.clockLabel.widthAnchor],
        [self.descriptionView.heightAnchor constraintEqualToAnchor:self.dateLabel.heightAnchor],

        [self.dateLabel.leadingAnchor constraintEqualToAnchor:self.descriptionView.leadingAnchor],
        [self.dateLabel.bottomAnchor constraintEqualToAnchor:self.descriptionView.bottomAnchor],

        [self.conditionLabel.leadingAnchor constraintEqualToAnchor:self.dateLabel.trailingAnchor constant:4],
        [self.conditionLabel.bottomAnchor constraintEqualToAnchor:self.descriptionView.bottomAnchor],

        [self.locationLabel.trailingAnchor constraintEqualToAnchor:self.descriptionView.trailingAnchor],
        [self.locationLabel.bottomAnchor constraintEqualToAnchor:self.descriptionView.bottomAnchor]
    ]];

    [super updateConstraints];
}

- (void)updateClock {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"h:mm"];
    self.clockLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    [self updateConstraints];
}
@end
