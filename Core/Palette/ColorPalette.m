@interface ColorPalette : NSObject
+ (instancetype)defaultPalette;
- (NSArray<UIColor *> *)lightBluePalette;
- (NSArray<UIColor *> *)purpleVariationPalette;
- (NSArray<UIColor *> *)lightToDarkPalette;
- (NSArray<UIColor *> *)rgbColorPalette;
- (NSArray<UIColor *> *)shuffleColors:(NSArray<UIColor *> *)colors;
@end

@implementation ColorPalette
+ (instancetype)defaultPalette {
    return [[self alloc] init];
}

- (NSArray<UIColor *> *)rgbColorPalette {
    NSArray<UIColor *> *originalPalette = @[
        [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0],  // Red
        [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0],  // Green
        [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0],  // Yellow
    ];
    
    return [self shuffleColors:originalPalette];
}

- (NSArray <UIColor *> *)lightBluePalette {
    NSArray<UIColor *> *originalPalette = @[
        [UIColor colorWithRed:0.6 green:0.7 blue:1.0 alpha:1.0],
        [UIColor colorWithRed:0.7 green:0.8 blue:1.0 alpha:1.0],
        [UIColor colorWithRed:0.5 green:0.6 blue:0.9 alpha:1.0],
        [UIColor colorWithRed:0.4 green:0.5 blue:0.8 alpha:1.0],
        [UIColor colorWithRed:0.3 green:0.4 blue:0.7 alpha:1.0]
    ];
    return [self shuffleColors:originalPalette];
}

- (NSArray<UIColor *> *)lightToDarkPalette {
    NSArray<UIColor *> *originalPalette = @[
        [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0], // Light Gray
        [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0], // Medium Gray
        [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0], // Dark Gray
        [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0], // Very Dark Gray
        [UIColor colorWithRed:0.9 green:0.7 blue:0.7 alpha:1.0], // Light Pink
        [UIColor colorWithRed:0.8 green:0.4 blue:0.4 alpha:1.0], // Medium Pink
        [UIColor colorWithRed:0.7 green:0.1 blue:0.1 alpha:1.0], // Dark Pink
        [UIColor colorWithRed:0.7 green:0.7 blue:0.9 alpha:1.0], // Light Blue
        [UIColor colorWithRed:0.4 green:0.4 blue:0.8 alpha:1.0], // Medium Blue
        [UIColor colorWithRed:0.1 green:0.1 blue:0.7 alpha:1.0] // Dark Blue
    ];
    return [self shuffleColors:originalPalette];
}

- (NSArray<UIColor *> *)purpleVariationPalette {
    NSArray<UIColor *> *originalPalette = @[
        [UIColor colorWithRed:0.4 green:0.0 blue:0.6 alpha:1.0],
        [UIColor colorWithRed:0.7 green:0.3 blue:0.5 alpha:1.0],
        [UIColor colorWithRed:0.5 green:0.1 blue:0.7 alpha:1.0],
        [UIColor colorWithRed:0.6 green:0.2 blue:0.8 alpha:1.0],
        [UIColor colorWithRed:0.8 green:0.4 blue:1.0 alpha:1.0]
    ];

    return [self shuffleColors:originalPalette];
}

- (NSArray<UIColor *> *)shuffleColors:(NSArray<UIColor *> *)colors {
    NSMutableArray<UIColor *> *shuffledColors = [colors mutableCopy];
    NSUInteger count = [shuffledColors count];
    for (NSUInteger i = 0; i < count; i++) {
        NSUInteger remainingCount = count - i;
        NSUInteger randomIndex = i + arc4random_uniform((uint32_t)remainingCount);
        [shuffledColors exchangeObjectAtIndex:i withObjectAtIndex:randomIndex];
    }
    return [shuffledColors copy];
}
@end