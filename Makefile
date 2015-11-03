




//FINALPACKAGE = 1
PACKAGE_VERSION = 1.69





ARCHS = armv7 armv7s arm64
TARGET = iphone:clang:latest





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




