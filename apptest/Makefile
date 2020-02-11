ARCHS = arm64
TARGET = iphone:latest:8.0
include $(THEOS)/makefiles/common.mk

THEOS_PLATFORM_DEB_COMPRESSION_TYPE=gzip

APPLICATION_NAME = apptest
apptest_FILES = AppDelegate.swift RootViewController.swift MatrixHandler.swift
apptest_FRAMEWORKS = UIKit CoreGraphics Foundation
apptest_EXTRA_FRAMEWORKS = AFNetworking GZIP libbase58 Realm OLMKit SwiftMatrixSDK
apptest_LDFLAGS += -F./layout/Library/Frameworks -rpath /Library/Frameworks

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall \"apptest\"" || true
