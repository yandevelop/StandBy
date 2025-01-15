TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = StandBy

StandBy_FILES = Tweak.x
StandBy_CFLAGS = -fobjc-arc
StandBy_FRAMEWORKS = UIKit Weather QuartzCore
StandBy_PRIVATE_FRAMEWORKS += Celestial MediaRemote AVFoundation

include $(THEOS_MAKE_PATH)/tweak.mk
