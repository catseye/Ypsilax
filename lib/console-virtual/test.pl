#!/usr/bin/perl -w
# test.pl - test program for Console::Virtual
# v2007.1122 Chris Pressey, Cat's Eye Technologies

# Copyright (c)2000-2007, Chris Pressey, Cat's Eye Technologies.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#  1. Redistributions of source code must retain the above copyright
#     notices, this list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright
#     notices, this list of conditions, and the following disclaimer in
#     the documentation and/or other materials provided with the
#     distribution.
#  3. Neither the names of the copyright holders nor the names of their
#     contributors may be used to endorse or promote products derived
#     from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
# COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# This line allows us to have the Console directory in the same
# directory as the test script.

BEGIN { use File::Basename; push @INC, dirname($0); }

# uncomment any of these lines to test with other setups
# BEGIN { $Console::Virtual::setup{input} = 'Screen'; $Console::Virtual::setup{display} = 'Screen'; }
# BEGIN { $Console::Virtual::setup{input} = 'POSIX'; $Console::Virtual::setup{display} = 'Tput'; }
# BEGIN { $Console::Virtual::setup{input} = 'Teletype'; $Console::Virtual::setup{display} = 'Teletype'; }

use Console::Virtual 2001.0127 qw(getkey display gotoxy clrscr clreol
                                  normal inverse bold update_display);

clrscr;
gotoxy(10,20);
display("Hello, world!");

gotoxy(20,10);
inverse();
display("Outta sight!");
normal();

# In this example, Console::Virtual's functions have been imported into
# package main.
# Because of this, code which relied on the old package 'vC' still works.

::gotoxy(1,1);
::bold();
::display("Rock on!");
::normal();

# So does explicitly referencing the 'Console::Virtual' package.
# In fact, if you leave out the qw() list on 'use Console::Virtual',
# you'll have to do it this way.

Console::Virtual::gotoxy(3,3);
Console::Virtual::update_display();

# getkey should automatically invoke update_display when appropriate.

display("Press a key: ");
$foo = getkey();
clrscr();
display("You pressed ", $foo, "!");
update_display;

### END of test.pl ###

