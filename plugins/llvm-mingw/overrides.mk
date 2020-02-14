# This file is part of MXE. See LICENSE.md for licensing information.

$(PLUGIN_HEADER)

IS_LLVM := $(true)

# Override sub-dependencies
cc_DEPS := llvm
llvm_DEPS := $(subst cc,llvm-mingw,$(llvm_DEPS))

# Update mingw-w64 to de5b740
# https://github.com/mingw-w64/mingw-w64/tarball/de5b7406d2858b378cf5f59728d7b5bacc3faeab
# Keep-in sync with:
# https://github.com/mstorsjo/llvm-mingw/blob/$(llvm-mingw_VERSION)/build-mingw-w64.sh#L21
mingw-w64_VERSION  := de5b740
mingw-w64_CHECKSUM := 15f73f0a847620b6e0ffac42a4b18ee390413f206946292de7b738476a343751
mingw-w64_SUBDIR   := mingw-w64-mingw-w64-$(mingw-w64_VERSION)
mingw-w64_FILE     := mingw-w64-mingw-w64-$(mingw-w64_VERSION).tar.gz
mingw-w64_URL      := https://github.com/mingw-w64/mingw-w64/tarball/$(mingw-w64_VERSION)/$(mingw-w64_FILE)

# libc++ uses Win32 threads to implement the internal
# threading API, so we do not need to build pthreads.
define pthreads_BUILD
    $(info $(PKG) is not built when the llvm-mingw plugin is used)
endef
