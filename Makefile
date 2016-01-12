




FINALPACKAGE = 1
DEBUG = 0
PACKAGE_VERSION = 1.0-6





ifeq ($(DEBUG), 1)
    ARCHS = arm64
else
    ARCHS = armv7 armv7s arm64
endif
TARGET = iphone:clang:latest:7.0





BUNDLE_NAME = iTunesSync
iTunesSync_INSTALL_PATH = /Library/Switches
iTunesSync_CFLAGS = -fobjc-arc
iTunesSync_FILES = iTunesSyncSwitch.xm
iTunesSync_FRAMEWORKS = UIKit
iTunesSync_LIBRARIES = flipswitch sw

ADDITIONAL_CFLAGS = -Ipublic





include theos/makefiles/common.mk
include theos/makefiles/tweak.mk
include theos/makefiles/bundle.mk
include theos/makefiles/library.mk
include theos/makefiles/swcommon.mk





after-install::
	install.exec "killall -9 backboardd"




