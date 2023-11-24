include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = StandByPreferences

THEOS_PACKAGE_SCHEME = rootless

StandByPreferences_FILES = SBPRootListController.m
StandByPreferences_FRAMEWORKS = UIKit
StandByPreferences_PRIVATE_FRAMEWORKS = Preferences
StandByPreferences_INSTALL_PATH = /Library/PreferenceBundles
StandByPreferences_CFLAGS = -fobjc-arc
StandByPreferences_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

StandByPreferences_LIBRARIES = gcuniversal

include $(THEOS_MAKE_PATH)/bundle.mk
