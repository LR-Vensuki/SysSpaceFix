# Scripts only, nothing to compile.
# iOS 4-7 dpkg can't unpack xz/zstd, so stick to gzip.
THEOS_PLATFORM_DEB_COMPRESSION_TYPE = gzip

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/null.mk
