#! /bin/sh
# Copyright (C) 1998-2013 Free Software Foundation, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Test to make sure rules to invoke all compilers are selected with
# mixed source objects.
# Matthew D. Langston <langston@SLAC.Stanford.EDU>

. test-init.sh

cat >> configure.ac << 'END'
AC_PROG_CC
AC_PROG_CXX
AC_PROG_F77
AC_F77_LIBRARY_LDFLAGS
END

cat > Makefile.am << 'END'
bin_PROGRAMS = foo
foo_SOURCES  = foo.f bar.c baz.cc
END

: > config.guess
: > config.sub

$ACLOCAL
$AUTOMAKE

$FGREP COMPILE Makefile.in # For debugging.

# Look for the macros at the beginning of rules.

sed -e "s|$tab *&& *|$tab|" \
    -e 's|$(AM_V_CC)||g' \
    -e 's|$(AM_V_CXX)||g' \
    -e 's|$(AM_V_F77)||g' \
  Makefile.in >mk
diff -u Makefile.in mk || : # For debugging.
$FGREP "$tab\$(COMPILE)"    mk
$FGREP "$tab\$(CXXCOMPILE)" mk
$FGREP "$tab\$(F77COMPILE)" mk

:
