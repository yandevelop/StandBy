#import <Foundation/Foundation.h>
#import "SBPRootListController.h"
#import <rootless.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>

@implementation SBPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (instancetype)init {
	self = [super init];

	if (self) {
		NSBundle *standByBundle = [NSBundle bundleWithPath:ROOT_PATH_NS(@"/Library/PreferenceBundles/StandByPreferences.bundle")];


		self.preferences = [[HBPreferences alloc] initWithIdentifier:@"com.yan.standbypreferences"];

		self.navigationItem.titleView = [[UIView alloc] init];

		self.enableSwitch = [[UISwitch alloc] init];
		[self.enableSwitch addTarget:self action:@selector(enableSwitchChanged) forControlEvents:UIControlEventValueChanged];
		self.enableSwitch.onTintColor = [UIColor colorWithRed:0.00 green:0.00 blue:0.38 alpha:1.00];

		self.item = [[UIBarButtonItem alloc] initWithCustomView:self.enableSwitch];
		self.navigationItem.rightBarButtonItem = self.item;
		[self.navigationItem setRightBarButtonItem:self.item];

		self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
		self.titleLabel.textColor = [UIColor blackColor];
		self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
		self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		self.titleLabel.text = @"StandBy";
		self.titleLabel.textAlignment = NSTextAlignmentCenter;
		[self.navigationItem.titleView addSubview:self.titleLabel];

		self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
		self.iconView.contentMode = UIViewContentModeScaleAspectFit;
		self.iconView.image = [UIImage imageNamed:@"icon.png" inBundle:standByBundle compatibleWithTraitCollection:nil];
		self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
		self.iconView.alpha = 0.0;
		[self.navigationItem.titleView addSubview:self.iconView];

		[NSLayoutConstraint activateConstraints:@[
			[self.titleLabel.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
			[self.titleLabel.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
			[self.titleLabel.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
			[self.titleLabel.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],

			[self.iconView.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
			[self.iconView.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
			[self.iconView.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
			[self.iconView.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor]
		]];
	}
	return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat offsetY = scrollView.contentOffset.y;

	if (offsetY > 100) {
		[UIView animateWithDuration: 0.2 animations:^{
			self.iconView.alpha = 1.0;
			self.titleLabel.alpha = 0.0;
		}];
	} else if (offsetY > -100 && offsetY < 110) {
		[UIView animateWithDuration:0.2 animations:^{
			self.iconView.alpha = 0.0;
			self.titleLabel.alpha = 1.0;
		}];
	} else {
		[UIView animateWithDuration:0.2 animations:^{
			self.iconView.alpha = 0.0;
			self.titleLabel.alpha = 0.0;
		}];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setEnabledState];

	//PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
	PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];

	NSMutableArray *allAssetArray = [NSMutableArray new];
	[smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
		NSString *albumTitle = collection.localizedTitle;
		NSLog(@"Standby Album Title: %@", albumTitle); // Log the album title once for each album

		PHFetchResult *assetsInCollection = [PHAsset fetchAssetsInAssetCollection:collection options:nil];

		[assetsInCollection enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger assetIdx, BOOL *assetStop) {
			[allAssetArray addObject:asset];
		}];
	}];

	NSLog(@"StandBy %@", allAssetArray);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	tableView.tableHeaderView = self.headerView;
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)enableSwitchChanged {
	if ([[self.preferences objectForKey:@"SBEnabled"] isEqual:@(YES)]) {
		[self.preferences setBool:NO forKey:@"SBEnabled"];
	} else {
		[self.preferences setBool:YES forKey:@"SBEnabled"];
	}

}

- (void)setEnabledState {
	if ([[self.preferences objectForKey:@"SBEnabled"] isEqual:@(YES)]) {
		[self.enableSwitch setOn:YES animated:YES];
	} else {
		[self.enableSwitch setOn:NO animated:YES];
	}
}

- (void)selectImages {

}

- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results {
    for (PHPickerResult *result in results) {
        NSItemProvider *itemProvider = result.itemProvider;
        
        if ([itemProvider canLoadObjectOfClass:[PHAssetCollection class]]) {
            [itemProvider loadObjectOfClass:[PHAssetCollection class] completionHandler:^(id<NSItemProviderReading> _Nullable object, NSError * _Nullable error) {
                if ([object isKindOfClass:[PHAssetCollection class]]) {
                    PHAssetCollection *selectedAlbum = (PHAssetCollection *)object;
                    NSString *albumIdentifier = selectedAlbum.localIdentifier;
                    
                    NSLog(@"Standby Selected Album ID: %@", albumIdentifier);
                } else {
                    NSLog(@"Standby Error loading album: %@", error);
                }
            }];
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)respring {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		[HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=Stella"]];
	});
}
@end
