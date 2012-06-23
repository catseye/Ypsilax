# Console::Display::Curses.pm - display layer for Curses
# v2007.1122 Chris Pressey, Cat's Eye Technologies

# Copyright (c)2001-2007, Chris Pressey, Cat's Eye Technologies.
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

use Curses;

### SUBS ###

$curses_x = 1;
$curses_y = 1;

sub display { my ($m) = join('',@_);
              addstr($curses_y-1, $curses_x-1, $m);
              $curses_x += length($m); }
sub clrscr  { $curses_x = 1; $curses_y = 1; move(0, 0); clear; refresh; }
sub clreol  { move($curses_y-1, $curses_x-1); clrtoeol; }
sub gotoxy  { ($curses_x, $curses_y) = @_; }
sub bold    { attrset(A_BOLD); } 
sub inverse { attrset(A_REVERSE); }
sub normal  { attrset(A_NORMAL); }
sub update_display { move($curses_y-1,$curses_x-1); refresh; }

1;

### END of Curses.pm ###
