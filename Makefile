export TARGET := iphone:clang:latest:14.0
export ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

GO_EASY_ON_ME = 1

THEOS_DEVICE_IP = 192.168.102.68

export SYSROOT = $(THEOS)/sdks/iPhoneOS15.5.sdk

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = StandBy

StandBy_FILES = Tweak.x
StandBy_CFLAGS = -fobjc-arc
StandBy_FRAMEWORKS = UIKit Weather QuartzCore
StandBy_PRIVATE_FRAMEWORKS += Celestial MediaRemote AVFoundation

StandBy_EXTRA_FRAMEWORKS += Cephei
StandBy_LIBRARIES = gcuniversal

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
