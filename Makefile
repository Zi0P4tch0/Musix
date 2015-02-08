export THEOS_DEVICE_IP=192.168.1.9

export TARGET = iphone:clang:8.1:8.0
export ARCHS = armv7 armv7s arm64

export THEOS_BUILD_DIR = ./debs
export PACKAGE_VERSION = 1.0.0

include theos/makefiles/common.mk

TWEAK_NAME = Musix
Musix_FILES = MPUNowPlayingViewController.xm \
	ZPNowPlayingItemInfoView.m \
	UIView+Positioning.m
Musix_FRAMEWORKS = MediaPlayer UIKit AVFoundation
Musix_PRIVATE_FRAMEWORKS = MusicUI MediaPlayerUI

include theos/makefiles/tweak.mk

after-install::
	install.exec "killall -9 Music MobileMusic"