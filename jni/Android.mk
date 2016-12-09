LOCAL_PATH := $(call my-dir)
GIT_VERSION := " $(shell git rev-parse --short HEAD || echo unknown)"
ifneq ($(GIT_VERSION)," unknown")
	LOCAL_CFLAGS += -DGIT_VERSION=\"$(GIT_VERSION)\"
endif

include $(CLEAR_VARS)

LOCAL_MODULE    := retro

ifeq ($(TARGET_ARCH),arm)
LOCAL_CFLAGS += -DANDROID_ARM
LOCAL_ARM_MODE := arm
ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
LOCAL_CFLAGS += -D__ARM_NEON__ -mfpu=neon
endif
endif

ifeq ($(TARGET_ARCH),x86)
LOCAL_CFLAGS +=  -DANDROID_X86
endif

ifeq ($(TARGET_ARCH),mips)
LOCAL_CFLAGS += -DANDROID_MIPS -D__mips__ -D__MIPSEL__
endif

USE_CODEC_WAVE=1
USE_CODEC_FLAC=0
USE_CODEC_VORBIS=0

CORE_DIR := ..

include $(CORE_DIR)/Makefile.common

LOCAL_SRC_FILES    += $(SOURCES_C)

LOCAL_C_INCLUDES = $(INCFLAGS)

ifeq ($(USE_CODEC_WAVE),1)
LOCAL_CFLAGS += -DUSE_CODEC_WAVE
endif
ifeq ($(USE_CODEC_FLAC),1)
LOCAL_CFLAGS += -DUSE_CODEC_VORBIS
endif
ifeq ($(USE_CODEC_VORBIS),1)
LOCAL_CFLAGS += -DUSE_CODEC_FLAC
endif

LOCAL_CFLAGS += $(INCFLAGS) -O3 -std=gnu99 -ffast-math -funroll-loops -DINLINE=inline -DNQ_HACK -DHAVE_STRINGS -DHAVE_INTTYPES_H -DQBASEDIR=. -DTYR_VERSION=0.62 -D__LIBRETRO__ -DFRONTEND_SUPPORTS_RGB565 -DANDROID $(INCFLAGS)

include $(BUILD_SHARED_LIBRARY)
