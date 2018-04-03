export ARCHS = armv7 arm64
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = DuplexClockXPrefs

DuplexClockXPrefs_FILES = DuplexClockXPrefs.m
DuplexClockXPrefs_INSTALL_PATH = /Library/PreferenceBundles
DuplexClockXPrefs_FRAMEWORKS = UIKit
DuplexClockXPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/DuplexClockXPrefs.plist$(ECHO_END)
