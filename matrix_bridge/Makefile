ARCHS = arm64
TARGET = iphone:latest:8.0
include $(THEOS)/makefiles/common.mk

THEOS_PLATFORM_DEB_COMPRESSION_TYPE=gzip

APPLICATION_NAME = matrixbridge
matrixbridge_FILES = AppDelegate.swift RootViewController.swift MatrixHandler.swift Helpers.swift
matrixbridge_FRAMEWORKS = UIKit CoreGraphics Foundation
matrixbridge_EXTRA_FRAMEWORKS = AFNetworking GZIP libbase58 Realm OLMKit SwiftMatrixSDK
matrixbridge_LDFLAGS += -F./layout/Library/Frameworks -rpath /Library/Frameworks

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall \"matrixbridge\"" || true
