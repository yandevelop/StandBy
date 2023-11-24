#import <objc/runtime.h>
#import "WeatherManager.h"

@interface WeatherManager ()
@property (nonatomic, strong, readonly) WALockscreenWidgetViewController *weatherWidget;
@end

@implementation WeatherManager
@dynamic currentTemperature;
@dynamic currentLocation;
@dynamic sunrise;
@dynamic sunset;
@dynamic weatherData;
@synthesize weatherWidget = _weatherWidget;

+ (instancetype)sharedInstance {
	static dispatch_once_t p = 0;
	static __strong WeatherManager *_sharedSelf = nil;
	dispatch_once(&p, ^{
		_sharedSelf = [[WeatherManager alloc] init];
	});
	return _sharedSelf;
}

- (WALockscreenWidgetViewController *)weatherWidget {
	if (_weatherWidget) {
		return _weatherWidget;
	}
	_weatherWidget = [[objc_getClass("WALockscreenWidgetViewController") alloc] init];
	return _weatherWidget;
}

- (void)refreshWeatherData {
    if ([self.weatherWidget respondsToSelector:@selector(updateWeather)]) {
        [self.weatherWidget updateWeather];
    }
    if ([self.weatherWidget respondsToSelector:@selector(_updateTodayView)]) {
        [self.weatherWidget _updateTodayView];
    }
}

- (NSDictionary *)weatherData {
	NSMutableDictionary *data = [NSMutableDictionary dictionary];
	if (self.currentTemperature) [data setObject:self.currentTemperature forKey:@"temperature"]; else [data setObject:@"N/A" forKey:@"temperature"];
	if (self.currentConditions) [data setObject:self.currentConditions forKey:@"conditions"]; else [data setObject:@"N/A" forKey:@"conditions"];
	if (self.currentLocation) [data setObject:self.currentLocation forKey:@"location"]; else [data setObject:@"N/A" forKey:@"location"];
	//if (self.sunrise) [data setObject:self.sunrise forKey:@"sunrise"];
	//if (self.sunset) [data setObject:self.sunset forKey:@"sunset"];
	return data;
}

- (NSString *)currentTemperature {
	if ([self.weatherWidget respondsToSelector:@selector(_temperature)]) {
		return [self.weatherWidget _temperature];
	}
	return @"N/A";
}

- (NSString *)currentLocation {
	NSString *loc = [self.weatherWidget _locationName];
	NSLog(@"[StandBy] location: %@", loc);
	if ([self.weatherWidget respondsToSelector:@selector(_locationName)]) {
		return [self.weatherWidget _locationName];
	}
	return @"N/A";
}

- (NSString *)conditionEmoji {
    
    WAForecastModel *model = [_weatherWidget currentForecastModel];
    WACurrentForecast *condition = [model currentConditions];
    NSInteger currentCode = [condition conditionCode];

    int hour = [[NSCalendar currentCalendar] component:NSCalendarUnitHour fromDate:[NSDate date]];

    NSString *weatherString;

	if (currentCode <= 2)
		weatherString = @"🌪";
	else if (currentCode <= 4)
		weatherString = @"⛈";
	else if (currentCode <= 8)
		weatherString = @"🌨";
	else if (currentCode == 9)
		weatherString = @"🌧";
	else if (currentCode == 10)
		weatherString = @"🌨";
	else if (currentCode <= 12)
		weatherString = @"🌧";
	else if (currentCode <= 18)
		weatherString = @"🌨";
	else if (currentCode <= 22)
		weatherString = @"🌫";
	else if (currentCode <= 24)
		weatherString = @"💨";
	else if (currentCode == 25)
		weatherString = @"❄️";
	else if (currentCode == 26)
		weatherString = @"☁️";
	else if (currentCode <= 28)
		weatherString = @"🌥";
	else if (currentCode <= 30)
		weatherString = @"⛅️";
	else if (currentCode <= 32 && (hour >= 18 || hour <= 6))
		weatherString = @"🌙";
	else if (currentCode <= 32)
		weatherString = @"☀️";
	else if (currentCode <= 34)
		weatherString = @"🌤";
	else if (currentCode == 35)
		weatherString = @"🌧";
	else if (currentCode == 36)
		weatherString = @"🔥";
	else if (currentCode <= 38)
		weatherString = @"🌩";
	else if (currentCode == 39)
		weatherString = @"🌦";
	else if (currentCode == 40)
		weatherString = @"🌧";
	else if (currentCode <= 43)
		weatherString = @"🌨";
	else
		weatherString = @"N/A";

    return weatherString;
}

- (NSString *)currentConditions {
	if ([self.weatherWidget respondsToSelector:@selector(_conditionsLine)]) {
		NSLog(@"[StandBy] weather: %@", [self.weatherWidget _conditionsLine]);
		return [self.weatherWidget _conditionsLine];
	}
	return @"N/A";
}
@end