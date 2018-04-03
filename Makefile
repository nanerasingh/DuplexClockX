export ARCHS = armv7 arm64
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DuplexClockX
DuplexClockX_FILES = Tweak.xm
DuplexClockX_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += duplexclockxprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
