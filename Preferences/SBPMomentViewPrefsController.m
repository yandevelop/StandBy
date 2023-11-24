#import "SBPMomentViewPrefsController.h"

@implementation SBPMomentViewPrefsController
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (id)specifiers {
    return _specifiers;
}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {
    NSString *sub = [specifier propertyForKey:@"SBPSub"];
    _specifiers = [self loadSpecifiersFromPlistName:sub target:self];
}

- (void)setSpecifier:(PSSpecifier *)specifier {
    [self loadFromSpecifier:specifier];
    [super setSpecifier:specifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [self reload];
    [super viewWillAppear:animated];
}
@end