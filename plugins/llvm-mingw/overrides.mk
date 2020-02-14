# This file is part of MXE. See LICENSE.md for licensing information.

$(PLUGIN_HEADER)

IS_LLVM := $(true)

# Override sub-dependencies
cc_DEPS := llvm
llvm_DEPS := $(subst cc,llvm-mingw,$(llvm_DEPS))

# Update mingw-w64 to e06d785
# https://github.com/mingw-w64/mingw-w64/tarball/e06d7853b292f6f81f200169092dd41ff92bca7e
# Keep-in sync with:
# https://github.com/mstorsjo/llvm-mingw/blob/$(llvm-mingw_VERSION)/build-mingw-w64.sh#L21
mingw-w64_VERSION  := e06d785
mingw-w64_CHECKSUM := f08b0efebb8221dedda44fc601e9aa3d786e5d7fa2c12f3e25bfa56b4b4f36fd
mingw-w64_SUBDIR   := mingw-w64-mingw-w64-$(mingw-w64_VERSION)
mingw-w64_FILE     := mingw-w64-mingw-w64-$(mingw-w64_VERSION).tar.gz
mingw-w64_URL      := https://github.com/mingw-w64/mingw-w64/tarball/$(mingw-w64_VERSION)/$(mingw-w64_FILE)

# libc++ uses Win32 threads to implement the internal
# threading API, so we do not need to build pthreads.
define pthreads_BUILD
    $(info $(PKG) is not built when the llvm-mingw plugin is used)
endef
