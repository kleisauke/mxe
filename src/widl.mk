# This file is part of MXE. See LICENSE.md for licensing information.

# WIDL is called "Wine IDL Compiler"; but we use mingw-w64's copy of it to
# avoid downloading Wine's entire tree.

PKG             := widl
$(PKG)_WEBSITE  := https://www.winehq.org/docs/widl/
$(PKG)_DESCR    := Wine IDL Compiler
$(PKG)_IGNORE    = $(mingw-w64_IGNORE)
$(PKG)_VERSION   = $(mingw-w64_VERSION)
$(PKG)_CHECKSUM  = $(mingw-w64_CHECKSUM)
$(PKG)_SUBDIR    = $(mingw-w64_SUBDIR)
$(PKG)_FILE      = $(mingw-w64_FILE)
$(PKG)_URL       = $(mingw-w64_URL)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo $(mingw-w64_VERSION)
endef

define $(PKG)_BUILD
    $(eval unexport CFLAGS)
    $(eval unexport CXXFLAGS)
    $(eval unexport LDFLAGS)

    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/mingw-w64-tools/widl/configure' \
        --host='$(BUILD)' \
        --build='$(BUILD)' \
        --prefix='$(PREFIX)' \
        --target='$(TARGET)' \
        $(if $(IS_LLVM), --with-widl-includedir='$(PREFIX)/$(TARGET)/$(PROCESSOR)-w64-mingw32/include')
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 $(INSTALL_STRIP_TOOLCHAIN)

    # create cmake file
    mkdir -p '$(CMAKE_TOOLCHAIN_DIR)'
    echo 'set(CMAKE_WIDL $(PREFIX)/bin/$(TARGET)-$(PKG) CACHE PATH "widl executable")' \
    > '$(CMAKE_TOOLCHAIN_DIR)/$(PKG).cmake'
endef
