@interface WeatherManager : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic, copy, readonly) NSString *currentTemperature;
@property (nonatomic, strong, readonly) NSDictionary *weatherData;
@property (nonatomic, copy, readonly) NSString *currentLocation;
@property (nonatomic, copy, readonly) NSString *currentConditions;
@property(nonatomic, strong, readonly) NSDate *sunrise;
@property(nonatomic, strong, readonly) NSDate *sunset;
@property (nonatomic, strong, readonly) NSString *conditionEmoji;
-(void)refreshWeatherData;
@end

@interface WFTemperature : NSObject
@property (assign,nonatomic) double celsius;
@property (assign,nonatomic) double fahrenheit;
@property (assign,nonatomic) double kelvin;
@end

@interface WADayForecast : NSObject
@property (nonatomic,copy) WFTemperature * high;
@property (nonatomic,copy) WFTemperature * low;
@end

@interface WACurrentForecast : NSObject
-(WFTemperature *)feelsLike;
@property(assign, nonatomic)long long conditionCode;
@end

@interface WAForecastModel : NSObject
-(NSDate *)sunrise;
-(NSDate *)sunset;
-(NSArray *)dailyForecasts;
@property(nonatomic,retain) WACurrentForecast* currentConditions;
@end

@interface WALockscreenWidgetViewController : UIViewController
-(WAForecastModel *)currentForecastModel;
-(id)_temperature;
-(id)_conditionsLine;
-(id)_locationName;
-(id)_conditionsImage;
-(void)_updateTodayView;
-(void)updateWeather;
@end