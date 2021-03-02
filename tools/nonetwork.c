// nonetwork, break standard network functions using LD_PRELOAD
// Source: https://github.com/starius/nonetwork
// Copyright (C) 2015 Boris Nagaev
// License: MIT

#define _GNU_SOURCE // required to get RTLD_NEXT defined

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>

int (*real_connect)(int sock, const void *addr, unsigned int len);
void *(*real_gethostbyname)(const char *name);
int (*real_getaddrinfo)(const char *node, const char *service,
                        const void *hints, void **res);
void (*real_freeaddrinfo)(void *res);
int (*real_getnameinfo)(const void *sa, unsigned int salen, char *host,
                        unsigned int hostlen, char *serv, unsigned int servlen,
                        int flags);
struct hostent *(*real_gethostbyaddr)(const void *addr, unsigned int len,
                                      int type);

int enable;
int silent;

__attribute__((constructor)) void init(void) {
  if (getenv("MXE_SILENT_NO_NETWORK"))
    silent = 1;

  if (!getenv("MXE_ENABLE_NETWORK"))
    return;

  real_connect = dlsym(RTLD_NEXT, "connect");
  if (!real_connect) {
    fprintf(stderr, "dlsym(real_connect) failed: %s\n", dlerror());
    exit(1);
  }

  real_gethostbyname = dlsym(RTLD_NEXT, "gethostbyname");
  if (!real_gethostbyname) {
    fprintf(stderr, "dlsym(gethostbyname) failed: %s\n", dlerror());
    exit(1);
  }

  real_getaddrinfo = dlsym(RTLD_NEXT, "getaddrinfo");
  if (!real_getaddrinfo) {
    fprintf(stderr, "dlsym(getaddrinfo) failed: %s\n", dlerror());
    exit(1);
  }

  real_freeaddrinfo = dlsym(RTLD_NEXT, "freeaddrinfo");
  if (!real_freeaddrinfo) {
    fprintf(stderr, "dlsym(freeaddrinfo) failed: %s\n", dlerror());
    exit(1);
  }

  real_getnameinfo = dlsym(RTLD_NEXT, "getnameinfo");
  if (!real_getnameinfo) {
    fprintf(stderr, "dlsym(getnameinfo) failed: %s\n", dlerror());
    exit(1);
  }

  real_gethostbyaddr = dlsym(RTLD_NEXT, "gethostbyaddr");
  if (!real_gethostbyaddr) {
    fprintf(stderr, "dlsym(gethostbyaddr) failed: %s\n", dlerror());
    exit(1);
  }

  enable = 1;
}

static void print_message() {
  if (!silent) {
    fflush(stderr);
    fprintf(stderr, "\nDon't use network from MXE build rules!\n");
    fprintf(stderr,
            "\tSilent mode for scripts reading stderr into variables:\n");
    fprintf(stderr, "\t\tMXE_SILENT_NO_NETWORK= make ...\n");
    fflush(stderr);
  }
}

int connect(int sock, const void *addr, unsigned int len) {
  if (!enable) {
    print_message();
    errno = 13; // EACCES, Permission denied
    return -1;
  }

  return real_connect(sock, addr, len);
}

void *gethostbyname(const char *name) {
  if (!enable) {
    print_message();
    return 0;
  }

  return real_gethostbyname(name);
}

int getaddrinfo(const char *node, const char *service, const void *hints,
                void **res) {
  if (!enable) {
    print_message();
    return -4; // EAI_FAIL
  }

  return real_getaddrinfo(node, service, hints, res);
}

void freeaddrinfo(void *res) {
  if (!enable) {
    print_message();
    return;
  }

  real_freeaddrinfo(res);
}

int getnameinfo(const void *sa, unsigned int salen, char *host,
                unsigned int hostlen, char *serv, unsigned int servlen,
                int flags) {
  if (!enable) {
    print_message();
    return -4; // EAI_FAIL
  }

  return real_getnameinfo(sa, salen, host, hostlen, serv, servlen, flags);
}

struct hostent *gethostbyaddr(const void *addr, unsigned int len, int type) {
  if (!enable) {
    print_message();
    return 0;
  }

  return real_gethostbyaddr(addr, len, type);
}
