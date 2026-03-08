# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := imath
$(PKG)_WEBSITE  := https://github.com/AcademySoftwareFoundation/Imath
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.2
$(PKG)_CHECKSUM := 0f5a783b424f374e6f27ec8b0c73130e89b08814ac8fa2e84fd7fe0b05862c53
$(PKG)_GH_CONF  := AcademySoftwareFoundation/Imath/releases,v
$(PKG)_SUBDIR   := Imath-$($(PKG)_VERSION)
$(PKG)_FILE     := Imath-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    mkdir -p '$(BUILD_DIR)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)' \
        -DCMAKE_BUILD_TYPE=Release
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-g++' \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-imath.exe' \
        `'$(TARGET)-pkg-config' Imath --cflags --libs`

endef
