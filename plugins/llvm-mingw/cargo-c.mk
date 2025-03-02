# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cargo-c
$(PKG)_WEBSITE  := https://github.com/lu-zero/cargo-c
$(PKG)_DESCR    := cargo applet to build and install C-ABI compatibile libraries
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.10.11
$(PKG)_CHECKSUM := 8a6d6dc589d6d70bd7eb95971e3c608240e1f9c938dd5b54a049977333b59f05
$(PKG)_GH_CONF  := lu-zero/cargo-c/tags,v
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_DEPS_$(BUILD) := $(BUILD)~rust

define $(PKG)_BUILD_$(BUILD)
    # Enable networking while we build cargo-c
    $(eval export MXE_ENABLE_NETWORK := 1)

    # Ensure that the downloaded build dependencies of Cargo are
    # stored in the build directory.
    $(eval export CARGO_HOME := $(BUILD_DIR)/.cargo)

    # Disable LTO, panic strategy and optimization settings while
    # we build cargo-c
    $(eval unexport CARGO_PROFILE_RELEASE_LTO)
    $(eval unexport CARGO_PROFILE_RELEASE_OPT_LEVEL)
    $(eval unexport CARGO_PROFILE_RELEASE_PANIC)

    cd '$(SOURCE_DIR)' && cargo build \
        --release

    cargo install \
        --path='$(SOURCE_DIR)' \
        --root='$(PREFIX)/$(BUILD)'
endef
