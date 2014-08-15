export ARCHS = armv7 armv7s arm64
export TARGET = iphone:clang:7.1:7.1

include theos/makefiles/common.mk

THEOS_DEVICE_IP = 192.168.1.149
THEOS_DEVICE_PORT = 22

BUNDLE_NAME = iTunesSync
iTunesSync_CFLAGS = -fobjc-arc
iTunesSync_FILES = Switch.x
iTunesSync_FRAMEWORKS = UIKit
iTunesSync_LIBRARIES = flipswitch
iTunesSync_INSTALL_PATH = /Library/Switches

include $(THEOS_MAKE_PATH)/bundle.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"