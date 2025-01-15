#import <AVFoundation/AVAudioSession.h>

@interface MusicView : UIView
@property (nonatomic, strong) UIView *artworkContainerView;
@property (nonatomic, strong) UIImageView *artworkImageView;

@property (nonatomic, strong) UIView *controlContainerView;

@property (nonatomic, strong) UIStackView *infoStackView;
@property (nonatomic, strong) UIStackView *songStackView;
@property (nonatomic, strong) UILabel *trackLabel;
@property (nonatomic, strong) UILabel *artistLabel;

@property (nonatomic, strong) UIStackView *controlStackView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) UIButton *rewindButton;

@property (nonatomic, strong) UIView *volumeContainerView;
@property (nonatomic, strong) UIButton *volumeButton;
@property (nonatomic, strong) UISlider *volumeSlider;
@end

@interface AVSystemController : NSObject
+ (instancetype)sharedAVSystemController;
- (BOOL)setVolumeTo:(float)volume forCategory:(NSString *)category;
- (BOOL)getVolume:(float *)volume forCategory:(NSString *)category;
@end

@interface SBApplication : NSObject
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (SBApplication *)nowPlayingApplication;
- (BOOL)isPlaying;
- (BOOL)playForEventSource:(long long)arg1;
- (BOOL)togglePlayPauseForEventSource:(long long)arg1;
- (BOOL)changeTrack:(int)arg1 eventSource:(long long)arg2;
- (void)setNowPlayingInfo:(id)arg1;
- (id)_nowPlayingInfo;
@end