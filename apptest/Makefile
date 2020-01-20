TARGET := iphone:clang:11.2:10.3
include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = apptest
apptest_FILES = AppDelegate.swift RootViewController.swift
apptest_FRAMEWORKS = UIKit CoreGraphics Foundation
apptest_EXTRA_FRAMEWORKS = AFNetworking

apptest_LDFLAGS += -rpath /Library/Frameworks

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall \"apptest\"" || true
