# Makefile has been adapted from https://github.com/clibs/ratelimit which has the following license:

#   Eric Radman
#
#   * Permission to use, copy, modify, and distribute this software for any
#   * purpose with or without fee is hereby granted, provided that the above
#   * copyright notice and this permission notice appear in all copies.
#   *
#   * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
#   * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
#   * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
#   * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
#   * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
#   * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
#   * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

BIN_NAME ?= ratelimit
CC ?= gcc
PREFIX ?= /usr/local
# MANPREFIX ?= ${PREFIX}/man
RELEASE = 0.0.1
CFLAGS += -DRELEASE=\"${RELEASE}\" -pedantic -Wall -Wpointer-arith -Wbad-function-cast
SRC ?= src

all: ratelimit # versioncheck

env:
	@echo "BIN_NAME   = ${BIN_NAME}"
	@echo "CC         = ${CC}"
	@echo "DESTDIR    = ${DESTDIR}"
	@echo "LDFLAGS    = ${LDFLAGS}"
	@echo "PREFIX     = ${PREFIX}"
	@echo "SRC        = ${SRC}"
#	@echo "MANPREFIX  = ${MANPREFIX}"

gcc-lint: clean
	@CFLAGS="-std=c89" BIN_NAME=ratelimit_c89 make ratelimit_c89
	rm -f ratelimit_c89 *.o

${BIN_NAME}: ${SRC}/ratelimit.c
	${CC} ${CFLAGS} src/ratelimit.c -o $@ ${LDFLAGS}

clean:
	rm -f ${BIN_NAME} *.o

install: ${BIN_NAME}
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	install ${BIN_NAME} ${DESTDIR}${PREFIX}/bin
#	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
#	install -m 644 ratelimit.1 ${DESTDIR}${MANPREFIX}/man1

uninstall:
	rm ${DESTDIR}${PREFIX}/bin/${BIN_NAME}
#	rm ${DESTDIR}${MANPREFIX}/man1/ratelimit.1

# versioncheck:
#	@head -n3 NEWS | egrep -q "^= Next Release: ${RELEASE}|^== ${RELEASE}: "

.PHONY: all env gcc-lint clean install uninstall # versioncheck
