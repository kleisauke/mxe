# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pe-util
$(PKG)_WEBSITE  := https://github.com/gsauthof/pe-util
$(PKG)_DESCR    := List shared object dependencies of a portable executable (PE)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := dc5dda5
$(PKG)_CHECKSUM := c3b926d8367154fb65a2d49f88cf1389e06a5ce0cc44c7b3526d901ecaba7e1d
$(PKG)_GH_CONF  := gsauthof/pe-util/branches/master
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := $(BUILD)~$(PKG)
$(PKG)_DEPS_$(BUILD) := cmake pe-parse

define $(PKG)_PRE_CONFIGURE
    # expects pe-parse in source tree as git submodule
    $(call PREPARE_PKG_SOURCE,pe-parse,$(BUILD_DIR))
    rm -rf '$(SOURCE_DIR)/pe-parse'
    mv '$(BUILD_DIR)/$(pe-parse_SUBDIR)' '$(SOURCE_DIR)/pe-parse'
endef

define $(PKG)_BUILD
    # install prefixed wrapper with default paths
    $(if $(BUILD_SHARED),
        (echo '#!/bin/sh'; \
         echo 'exec "$(PREFIX)/$(BUILD)/bin/peldd" \
                    --clear-path \
                    --path "$(PREFIX)/$(TARGET)/bin" \
                    --path "$(PREFIX)/$(TARGET)/qt5/bin" \
                    --wlist uxtheme.dll \
                    --wlist opengl32.dll \
                    --wlist userenv.dll \
                    "$$@"') \
                 > '$(PREFIX)/bin/$(TARGET)-peldd'
        chmod 0755 '$(PREFIX)/bin/$(TARGET)-peldd'
    )
endef

define $(PKG)_BUILD_$(BUILD)
    $($(PKG)_PRE_CONFIGURE)
    # build and install the binary
    '$(TARGET)-cmake' -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)'
    '$(TARGET)-cmake' --build '$(BUILD_DIR)' -j '$(JOBS)'
    '$(TARGET)-cmake' --install '$(BUILD_DIR)'
endef
