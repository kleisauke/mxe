# This file is part of MXE. See LICENSE.md for licensing information.

$(PLUGIN_HEADER)

IS_LLVM := $(true)

# Override sub-dependencies
cc_DEPS := llvm
llvm_DEPS := $(subst cc,llvm-mingw,$(llvm_DEPS))

# Update mingw-w64 to 57b5950
# https://github.com/mingw-w64/mingw-w64/tarball/57b595039040eaa15bece85b7cc71d952281b269
# Keep-in sync with:
# https://github.com/mstorsjo/llvm-mingw/blob/$(llvm-mingw_VERSION)/build-mingw-w64.sh#L21
mingw-w64_VERSION  := 57b5950
mingw-w64_CHECKSUM := 7362a2dc2d289dde4617e21e5d7a006c87c19e80793c8928a794b654ed6e2bcd
mingw-w64_SUBDIR   := mingw-w64-mingw-w64-$(mingw-w64_VERSION)
mingw-w64_FILE     := mingw-w64-mingw-w64-$(mingw-w64_VERSION).tar.gz
mingw-w64_URL      := https://github.com/mingw-w64/mingw-w64/tarball/$(mingw-w64_VERSION)/$(mingw-w64_FILE)

# libc++ uses Win32 threads to implement the internal
# threading API, so we do not need to build pthreads.
define pthreads_BUILD
    $(info $(PKG) is not built when the llvm-mingw plugin is used)
endef
