# Makefile for `wget' utility
# Copyright (C) 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003,
# 2004, 2005, 2006, 2007, 2008 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Wget.  If not, see <http://www.gnu.org/licenses/>.

# Additional permission under GNU GPL version 3 section 7

# If you modify this program, or any covered work, by linking or
# combining it with the OpenSSL project's OpenSSL library (or a
# modified version of that library), containing parts covered by the
# terms of the OpenSSL or SSLeay licenses, the Free Software Foundation
# grants you additional permission to convey the resulting work.
# Corresponding Source for a non-source form of such a combination
# shall include the source code for the parts of OpenSSL used as well
# as that of the covered work.

#
# Version: 1.11.4
#

SHELL = /bin/sh

top_builddir = ..

top_srcdir = ..
srcdir     = .


prefix       = /usr/local
exec_prefix  = ${prefix}
bindir       = ${exec_prefix}/bin
sysconfdir   = ${prefix}/etc
datadir      = ${prefix}/share
localedir    = $(datadir)/locale

DESTDIR      =

CC       = cc
CPPFLAGS = 
# The following line is losing on some versions of make!
DEFS     = -DHAVE_CONFIG_H -DSYSTEM_WGETRC=\"$(sysconfdir)/wgetrc\" -DLOCALEDIR=\"$(localedir)\"
CFLAGS   =  -O
LDFLAGS  =  
LIBS     =   
exeext   = .exe

INCLUDES = -I. -I$(srcdir) -I$(srcdir)/../src

COMPILE = $(CC) $(INCLUDES) $(CPPFLAGS) $(DEFS) $(CFLAGS)
LINK    = $(CC) $(CFLAGS) $(LDFLAGS) -o $@
INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = ${INSTALL}
RM = rm -f
ETAGS = etags

# Conditional compiles
ALLOCA     = 
MD5_OBJ    = gen-md5.o gnu-md5.o
OPIE_OBJ   = ftp-opie.o
NTLM_OBJ   = 
SSL_OBJ    = 
GETOPT_OBJ = 


all:

.PHONY: test

test: run-unit-tests run-px-tests

../src/wget:
	cd .. && $(MAKE)

run-unit-tests: unit-tests$(exeext)
	./unit-tests$(exeext)

run-px-tests: WgetTest.pm
	./Test-proxied-https-auth.px && echo && echo
	./Test-proxy-auth-basic.px && echo && echo
	./Test-auth-basic.px && echo && echo
	./Test-c-full.px && echo && echo
	./Test-c-partial.px && echo && echo
	./Test-c.px && echo && echo
	./Test-E-k-K.px && echo && echo
	./Test-E-k.px && echo && echo
	./Test-ftp.px && echo && echo
	./Test-HTTP-Content-Disposition-1.px && echo && echo
	./Test-HTTP-Content-Disposition-2.px && echo && echo
	./Test-HTTP-Content-Disposition.px && echo && echo
	./Test-N-current-HTTP-CD.px && echo && echo
	./Test-N-current.px && echo && echo
	./Test-N-HTTP-Content-Disposition.px && echo && echo
	./Test-N--no-content-disposition.px && echo && echo
	./Test-N--no-content-disposition-trivial.px && echo && echo
	./Test--no-content-disposition.px && echo && echo
	./Test--no-content-disposition-trivial.px && echo && echo
	./Test-N-old.px && echo && echo
	./Test-nonexisting-quiet.px && echo && echo
	./Test-noop.px && echo && echo
	./Test-np.px && echo && echo
	./Test-N.px && echo && echo
	./Test-O-HTTP-Content-Disposition.px && echo && echo
	./Test-O--no-content-disposition.px && echo && echo
	./Test-O--no-content-disposition-trivial.px && echo && echo
	./Test-O-nonexisting.px && echo && echo
	./Test-O.px && echo && echo
	./Test-Restrict-Lowercase.px && echo && echo
	./Test-Restrict-Uppercase.px && echo && echo
	./Test--spider-fail.px && echo && echo
	./Test--spider-HTTP-Content-Disposition.px && echo && echo
	./Test--spider--no-content-disposition.px && echo && echo
	./Test--spider--no-content-disposition-trivial.px && echo && echo
	./Test--spider.px && echo && echo
	./Test--spider-r-HTTP-Content-Disposition.px && echo && echo
	./Test--spider-r--no-content-disposition.px && echo && echo
	./Test--spider-r--no-content-disposition-trivial.px && echo && echo
	./Test--spider-r.px && echo && echo

WgetTest.pm: WgetTest.pm.in ../config.status
	cd .. && ./config.status

#
# Dependencies for test binary
#

TESTOBJ = $(ALLOCA) cmpt.o connect.o convert.o cookies.o              \
          ftp.o ftp-basic.o ftp-ls.o $(OPIE_OBJ) $(GETOPT_OBJ) hash.o \
          host.o html-parse.o html-url.o http.o $(NTLM_OBJ) init.o    \
          log.o main.o $(MD5_OBJ) netrc.o progress.o                  \
          ptimer.o recur.o res.o retr.o safe-ctype.o snprintf.o       \
          spider.o $(SSL_OBJ) test.o url.o utils.o version.o xmalloc.o

# We make object files depend on every header.  Rather than attempt to
# track dependencies, everything gets recompiled when a header
# changes.  With a program of Wget's size this doesn't waste much
# time, and it's a lot safer than attempting to get all the
# dependencies right.

HEADERS = ../src/config-post.h ../src/config.h                 \
	  ../src/connect.h ../src/convert.h ../src/cookies.h   \
	  ../src/ftp.h ../src/gen-md5.h ../src/getopt.h        \
	  ../src/gnu-md5.h ../src/hash.h ../src/host.h         \
	  ../src/html-parse.h ../src/http-ntlm.h ../src/init.h \
	  ../src/log.h ../src/mswindows.h ../src/netrc.h       \
	  ../src/options.h ../src/progress.h                   \
	  ../src/ptimer.h ../src/recur.h ../src/res.h          \
	  ../src/retr.h ../src/safe-ctype.h ../src/spider.h    \
	  ../src/ssl.h ../src/sysdep.h ../src/test.h           \
	  ../src/url.h ../src/utils.h ../src/wget.h            \
	  ../src/xmalloc.h

alloca.o: ../src/alloca.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

ccache.o: ../src/ccache.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

cmpt.o: ../src/cmpt.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

connect.o: ../src/connect.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

convert.o: ../src/convert.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

cookies.o: ../src/cookies.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

ftp-basic.o: ../src/ftp-basic.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

ftp.o: ../src/ftp.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

ftp-ls.o: ../src/ftp-ls.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

ftp-opie.o: ../src/ftp-opie.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

gen-md5.o: ../src/gen-md5.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

getopt.o: ../src/getopt.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

gnu-md5.o: ../src/gnu-md5.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

gnutls.o: ../src/gnutls.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

hash.o: ../src/hash.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

host.o: ../src/host.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

html-parse.o: ../src/html-parse.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

html-url.o: ../src/html-url.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

http.o: ../src/http.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

http-ntlm.o: ../src/http-ntlm.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

init.o: ../src/init.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

log.o: ../src/log.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

main.o: ../src/main.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

mswindows.o: ../src/mswindows.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

netrc.o: ../src/netrc.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

openssl.o: ../src/openssl.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

progress.o: ../src/progress.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

protocol.o: ../src/protocol.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

ptimer.o: ../src/ptimer.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

recur.o: ../src/recur.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

res.o: ../src/res.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

retr.o: ../src/retr.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

safe-ctype.o: ../src/safe-ctype.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

snprintf.o: ../src/snprintf.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

spider.o: ../src/spider.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

test.o: ../src/test.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

url.o: ../src/url.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

utils.o: ../src/utils.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

version.o: ../src/version.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

xmalloc.o: ../src/xmalloc.c $(HEADERS)
	$(COMPILE) -DTESTING -c $<

	
unit-tests$(exeext): $(TESTOBJ)
	$(LINK) $(TESTOBJ) $(LIBS)

#
# Dependencies for cleanup
#

clean:
	$(RM) *.o unit-tests$(exeext) *~ *.bak core core.[0-9]*

distclean: clean
	$(RM) Makefile

realclean: distclean

#
# Dependencies for maintenance
#

subdir = tests

Makefile: Makefile.in ../config.status
	cd .. && CONFIG_FILES=$(subdir)/$@ CONFIG_HEADERS= ./config.status

../src/config.h:
