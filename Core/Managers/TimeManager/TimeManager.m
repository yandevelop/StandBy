#import "TimeManager.h"

@implementation TimeManager {
    NSTimer *_updateTimer;
}

+ (instancetype)sharedInstance {
    static TimeManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TimeManager alloc] init];
    });
    return sharedInstance;
}

- (void)startUpdating {
    [self stopUpdating];

    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendNotification) userInfo:nil repeats:YES];
}

- (void)stopUpdating {
    [_updateTimer invalidate];
    _updateTimer = nil;
}

- (void)sendNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TimeChanged" object:nil userInfo:@{@"currentTime": [self currentTime]}];
}

- (NSString *)currentTime {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"h:mm"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (NSString *)currentDateWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:[NSDate date]];
}
@end