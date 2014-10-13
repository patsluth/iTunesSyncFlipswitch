THEOS_PACKAGE_DIR_NAME = debs
THEOS_DEVICE_IP = 192.168.1.149
THEOS_DEVICE_PORT = 22
ARCHS = armv7 armv7s arm64
TARGET = iphone:clang:latest:7.0

BUNDLE_NAME = iTunesSync
iTunesSync_CFLAGS = -fobjc-arc
iTunesSync_FILES = Switch.xm
iTunesSync_FRAMEWORKS = UIKit
iTunesSync_LIBRARIES = substrate flipswitch sw
iTunesSync_INSTALL_PATH = /Library/Switches

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/bundle.mk
include $(THEOS_MAKE_PATH)/library.mk

after-install::
	@install.exec "killall -9 SpringBoard"