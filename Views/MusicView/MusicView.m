#import "MusicView.h"
#import <MediaRemote/MediaRemote.h>

@implementation UIImage (MusicView)
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

@implementation MusicView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.artworkContainerView = [[UIView alloc] init];
        self.artworkContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.artworkContainerView];

        self.artworkImageView = [[UIImageView alloc] init];
        self.artworkImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.artworkImageView.layer.cornerRadius = 12.0;
        self.artworkImageView.clipsToBounds = YES;
        [self.artworkContainerView addSubview:self.artworkImageView];

        [NSLayoutConstraint activateConstraints:@[
            [self.artworkContainerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [self.artworkContainerView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.47],
            [self.artworkContainerView.heightAnchor constraintEqualToAnchor:self.heightAnchor],

            [self.artworkImageView.centerYAnchor constraintEqualToAnchor:self.artworkContainerView.centerYAnchor],
            [self.artworkImageView.widthAnchor constraintEqualToAnchor:self.artworkContainerView.widthAnchor multiplier:0.75],
            [self.artworkImageView.heightAnchor constraintEqualToAnchor:self.artworkImageView.widthAnchor],
            [self.artworkImageView.centerXAnchor constraintEqualToAnchor:self.artworkContainerView.centerXAnchor]
        ]];

        self.controlContainerView = [[UIView alloc] init];
        self.controlContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.controlContainerView];

        self.volumeContainerView = [[UIView alloc] init];
        self.volumeContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        self.volumeContainerView.alpha = 0.0;
        [self.controlContainerView addSubview:self.volumeContainerView];

        self.volumeButton = [[UIButton alloc] init];
        self.volumeButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.volumeButton.tintColor = [UIColor whiteColor];
        self.volumeButton.adjustsImageWhenHighlighted = NO;
        [self.volumeButton addTarget:self action:@selector(volumeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.volumeButton setImage:[[UIImage systemImageNamed:@"speaker.wave.2.fill"] imageWithConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:27.5]] forState:UIControlStateNormal];
        [self.controlContainerView addSubview:self.volumeButton];

        self.volumeSlider = [[UISlider alloc] init];
        self.volumeSlider.translatesAutoresizingMaskIntoConstraints = NO;
        [self.volumeSlider setThumbImage:[UIImage new] forState:UIControlStateNormal];
        [self.volumeSlider setThumbImage:[UIImage new] forState:UIControlStateHighlighted];
        self.volumeSlider.minimumValue = 0.0;
        self.volumeSlider.maximumValue = 1.0;
        self.volumeSlider.minimumTrackTintColor = [UIColor whiteColor];
        [self.volumeSlider addTarget:self action:@selector(setVolumeTo:) forControlEvents:UIControlEventValueChanged];
        [self.volumeContainerView addSubview:self.volumeSlider];

        self.infoStackView = [[UIStackView alloc] init];
        self.infoStackView.axis = UILayoutConstraintAxisVertical;
        self.infoStackView.distribution = UIStackViewDistributionEqualSpacing;
        self.infoStackView.alignment = UIStackViewAlignmentCenter;
        self.infoStackView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.controlContainerView addSubview:self.infoStackView];

        self.songStackView = [[UIStackView alloc] init];
        self.songStackView.axis = UILayoutConstraintAxisVertical;
        self.songStackView.distribution = UIStackViewDistributionEqualSpacing;
        self.songStackView.alignment = UIStackViewAlignmentCenter;
        self.songStackView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.infoStackView addArrangedSubview:self.songStackView];

        self.trackLabel = [[UILabel alloc] init];
        self.trackLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.trackLabel.textColor = [UIColor whiteColor];
        self.trackLabel.font = [UIFont boldSystemFontOfSize:42];
        [self.songStackView addArrangedSubview:self.trackLabel];

        self.artistLabel = [[UILabel alloc] init];
        self.artistLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.artistLabel.textColor = [UIColor whiteColor];
        self.artistLabel.font = [UIFont systemFontOfSize:28];
        [self.songStackView addArrangedSubview:self.artistLabel];

        [NSLayoutConstraint activateConstraints:@[
            [self.controlContainerView.leadingAnchor constraintEqualToAnchor:self.artworkContainerView.trailingAnchor],
            [self.controlContainerView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.53],
            [self.controlContainerView.heightAnchor constraintEqualToAnchor:self.heightAnchor],

            [self.trackLabel.widthAnchor constraintLessThanOrEqualToAnchor:self.controlContainerView.widthAnchor multiplier:0.75],

            [self.infoStackView.centerXAnchor constraintEqualToAnchor:self.controlContainerView.centerXAnchor],
            [self.infoStackView.centerYAnchor constraintEqualToAnchor:self.controlContainerView.centerYAnchor],
            [self.infoStackView.widthAnchor constraintEqualToAnchor:self.controlContainerView.widthAnchor multiplier:0.75],
            [self.infoStackView.heightAnchor constraintEqualToAnchor:self.controlContainerView.heightAnchor multiplier:0.5],
        ]];

        self.controlStackView = [[UIStackView alloc] init];
        self.controlStackView.axis = UILayoutConstraintAxisHorizontal;
        self.controlStackView.distribution = UIStackViewDistributionEqualSpacing;
        self.controlStackView.alignment = UIStackViewAlignmentCenter;
        self.controlStackView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.infoStackView addArrangedSubview:self.controlStackView];

        self.rewindButton = [[UIButton alloc] init];
        self.rewindButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.rewindButton.tintColor = [UIColor whiteColor];
        self.rewindButton.adjustsImageWhenHighlighted = NO;
        [self.rewindButton setImage:[[UIImage systemImageNamed:@"backward.fill"] imageWithConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:45]] forState:UIControlStateNormal];
        [self.rewindButton addTarget:self action:@selector(togglePlayback) forControlEvents:UIControlEventTouchUpInside];
        [self.controlStackView addArrangedSubview:self.rewindButton];

        self.playButton = [[UIButton alloc] init];
        self.playButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.playButton.tintColor = [UIColor whiteColor];
        self.playButton.adjustsImageWhenHighlighted = NO;
        [self.playButton setImage:[[UIImage systemImageNamed:@"play.fill"] imageWithConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:65]] forState:UIControlStateNormal];
        [self.playButton addTarget:self action:@selector(togglePlayback) forControlEvents:UIControlEventTouchUpInside];
        [self.controlStackView addArrangedSubview:self.playButton];

        self.skipButton = [[UIButton alloc] init];
        self.skipButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.skipButton.adjustsImageWhenHighlighted = NO;
        self.skipButton.tintColor = [UIColor whiteColor];
        [self.skipButton setImage:[[UIImage systemImageNamed:@"forward.fill"] imageWithConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:45]] forState:UIControlStateNormal];
        [self.skipButton addTarget:self action:@selector(togglePlayback) forControlEvents:UIControlEventTouchUpInside];
        [self.controlStackView addArrangedSubview:self.skipButton];

        [NSLayoutConstraint activateConstraints:@[
            [self.controlStackView.widthAnchor constraintEqualToAnchor:self.infoStackView.widthAnchor multiplier:0.9],
        ]];

        MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
            if (information) {
                NSDictionary* dict = (__bridge NSDictionary *)information;
                if (dict) {
                    UIImage* artwork = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];
                    NSString* title = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoTitle];
                    NSString* artist = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtist];
                    //NSString* album = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoAlbum];

                    if ([title containsString:@"•"]) {
                        NSArray *components = [title componentsSeparatedByString:@"•"];
                        NSMutableArray *songInfo = [NSMutableArray array];

                        for (NSString *component in components) {
                            NSString *cleanedComponent = [component stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                            [songInfo addObject:cleanedComponent];
                        }

                        self.trackLabel.text = songInfo[0];
                        self.artistLabel.text = songInfo[1];
                    }
                    self.artworkImageView.image = artwork;
                }
            }
        });

        // Set the constraints for the volume button here bc if i set them earlier the imageView gets disrupted??
        [NSLayoutConstraint activateConstraints:@[
            [self.volumeButton.bottomAnchor constraintEqualToAnchor:self.infoStackView.topAnchor],
            [self.volumeButton.leadingAnchor constraintEqualToAnchor:self.controlContainerView.leadingAnchor],
            [self.volumeButton.heightAnchor constraintEqualToConstant:27.5],

            [self.volumeContainerView.leadingAnchor constraintEqualToAnchor:self.volumeButton.trailingAnchor constant:5],
            [self.volumeContainerView.centerYAnchor constraintEqualToAnchor:self.volumeButton.centerYAnchor],
            [self.volumeContainerView.widthAnchor constraintEqualToConstant:100],
            [self.volumeContainerView.heightAnchor constraintEqualToAnchor:self.volumeButton.heightAnchor],

            [self.volumeSlider.leadingAnchor constraintEqualToAnchor:self.volumeContainerView.leadingAnchor],
            [self.volumeSlider.trailingAnchor constraintEqualToAnchor:self.volumeContainerView.trailingAnchor],
            [self.volumeSlider.topAnchor constraintEqualToAnchor:self.volumeContainerView.topAnchor],
            [self.volumeSlider.bottomAnchor constraintEqualToAnchor:self.volumeContainerView.bottomAnchor],
        ]];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMediaPlayer) name:@"MusicChanged" object:nil];

        [self addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"alpha"]) {
        CGFloat newAlpha = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        
        if (newAlpha == 1.0) {
            [self updateMediaPlayer];
        } else {
            self.volumeContainerView.alpha = 0.0;
        }
    }
}

- (void)setVolumeTo:(UISlider *)slider {
    CGFloat volume = slider.value;
    [[AVSystemController sharedAVSystemController] setVolumeTo:volume forCategory:@"Audio/Video"];
}

- (void)volumeButtonTapped {
    BOOL isSliderVisible = self.volumeContainerView.alpha;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isSliderVisible) {
            self.volumeSlider.userInteractionEnabled = NO;
            // Hide the slider with alpha animation
            [UIView animateWithDuration:0.3 animations:^{
                self.volumeContainerView.alpha = 0.0;
            }];
        } else {
            self.volumeSlider.userInteractionEnabled = YES;
            float volume;
            [[AVSystemController sharedAVSystemController] getVolume:&volume forCategory:@"Audio/Video"];
            [self.volumeSlider setValue:volume animated:YES];
            // Show the slider with alpha animation
            [UIView animateWithDuration:0.3 animations:^{
                self.volumeContainerView.alpha = 1.0;
            }];
        }
    });
}

- (void)updateMediaPlayer:(NSNotification *)notification {
    BOOL isPlaying = notification.userInfo[@"isPlaying"];

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        if (information) {
            NSDictionary* dict = (__bridge NSDictionary *)information;
            if (dict) {
                UIImage* artwork = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];
                NSString *title = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoTitle];
                NSString *artist = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtist];
                //NSString* album = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoAlbum];

                if (isPlaying) {
                    UIImage* pauseImage = [[UIImage systemImageNamed:@"pause.fill"] imageWithConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:27.5]];
                    [[self playButton] setImage:pauseImage forState:UIControlStateNormal];
                } else {
                    UIImage* playImage = [[UIImage systemImageNamed:@"play.fill"] imageWithConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:27.5]];
                    [[self playButton] setImage:playImage forState:UIControlStateNormal];
                }

                if (title && artwork) {
                    if ([title containsString:@"•"]) {
                        NSArray *components = [title componentsSeparatedByString:@"•"];
                        NSMutableArray *songInfo = [NSMutableArray array];

                        for (NSString *component in components) {
                            NSString *cleanedComponent = [component stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                            [songInfo addObject:cleanedComponent];
                        }

                        self.trackLabel.text = songInfo[0];
                        self.artistLabel.text = songInfo[1];
                    }
                    self.artworkImageView.image = artwork;
                } else {
                    self.trackLabel.text = @"Not playing";
                    self.artistLabel.text = @"";
                    self.artworkImageView.image = nil;
                }
            }
        }
    });
}

- (void)updateMediaPlayer {
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        if (information) {
            NSDictionary* dict = (__bridge NSDictionary *)information;
            if (dict) {
                UIImage* artwork = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];
                NSString *title = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoTitle];
                NSString *artist = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtist];
                //NSString* album = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoAlbum];

                if (title && artwork) {
                    if ([title containsString:@"•"]) {
                        NSArray *components = [title componentsSeparatedByString:@"•"];
                        NSMutableArray *songInfo = [NSMutableArray array];

                        for (NSString *component in components) {
                            NSString *cleanedComponent = [component stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                            [songInfo addObject:cleanedComponent];
                        }

                        self.trackLabel.text = songInfo[0];
                        self.artistLabel.text = songInfo[1];
                    }
                    self.artworkImageView.image = artwork;
                } else {
                    self.trackLabel.text = @"Not playing";
                    self.artistLabel.text = @"";
                    self.artworkImageView.image = nil;
                }
            }
        }
    });
}

- (void)togglePlayback {
    /*
    if (![[SBMediaController sharedInstance] _nowPlayingInfo]) { // check if music is already playing
        [[SBMediaController sharedInstance] playForEventSource:0];
    } else {
        [[SBMediaController sharedInstance] togglePlayPauseForEventSource:0];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TogglePlayback" object:nil];*/
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"alpha"];
}
@end