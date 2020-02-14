# This file is part of MXE. See LICENSE.md for licensing information.

$(PLUGIN_HEADER)

IS_LLVM := $(true)

# Override sub-dependencies
cc_DEPS := llvm
llvm_DEPS := $(subst cc,llvm-mingw,$(llvm_DEPS))

# Update mingw-w64 to c4ae0f4
# https://github.com/mingw-w64/mingw-w64/tarball/c4ae0f47b9adf0b6b91dcc906f5b1fbfe342bb42
# Keep-in sync with:
# https://github.com/mstorsjo/llvm-mingw/blob/$(llvm-mingw_VERSION)/build-mingw-w64.sh#L21
mingw-w64_VERSION  := c4ae0f4
mingw-w64_CHECKSUM := 8fecda318b6afb111b5db7279c94e4e5985ad41350c29c5dc5069b8e999d4377
mingw-w64_SUBDIR   := mingw-w64-mingw-w64-$(mingw-w64_VERSION)
mingw-w64_FILE     := mingw-w64-mingw-w64-$(mingw-w64_VERSION).tar.gz
mingw-w64_URL      := https://github.com/mingw-w64/mingw-w64/tarball/$(mingw-w64_VERSION)/$(mingw-w64_FILE)

# libc++ uses Win32 threads to implement the internal
# threading API, so we do not need to build pthreads.
define pthreads_BUILD
    $(info $(PKG) is not built when the llvm-mingw plugin is used)
endef
