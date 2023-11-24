#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <Cephei/HBPreferences.h>
#import <Cephei/HBRespringController.h>
#import <rootless.h>
#import <PhotosUI/PhotosUI.h>
#import <GcUniversal/GcColorPickerUtils.h>

#import "SBPMomentViewPrefsController.m"


@interface SBPRootListController : HBRootListController <PHPickerViewControllerDelegate>
@property (nonatomic, retain) HBPreferences *preferences;
@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIView *headerView;
@property(nonatomic, retain) UISwitch *enableSwitch;
@property(nonatomic, retain) UIBarButtonItem *item;
@end
