export THEOS_DEVICE_IP=10.43.1.235
export TARGET = iphone:clang:8.2:8.0
export ARCHS = armv7 arm64

export THEOS_BUILD_DIR = ./debs
export PACKAGE_VERSION = 1.0.0

include theos/makefiles/common.mk

TWEAK_NAME = Musix
Musix_FILES = MPUNowPlayingViewController.xm \
	ZPNowPlayingItemInfoView.m 
Musix_FRAMEWORKS = MediaPlayer UIKit AVFoundation CoreGraphics
Musix_PRIVATE_FRAMEWORKS = MusicUI MediaPlayerUI

include theos/makefiles/tweak.mk

after-install::
	install.exec "killall -9 Music MobileMusic"