@interface TimeManager : NSObject
+ (instancetype)sharedInstance;
- (void)startUpdating;
- (void)stopUpdating;

- (NSString *)currentTime;
- (NSString *)currentDateWithFormat:(NSString *)format;
@end