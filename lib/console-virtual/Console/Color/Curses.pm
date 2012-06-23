# Curses.pm - color abstraction for Curses

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

use Curses;

%::colormap =
(
  'black'    => 1,
  'red'      => 2,
  'blue'     => 3,
  'purple'   => 4,
  'green'    => 5,
  'brown'    => 6,
  'aqua'     => 7,
  'grey'     => 0,
  'pink'     => 18,
  'sky'      => 19,
  'magenta'  => 20,
  'lime'     => 21,
  'yellow'   => 22,
  'cyan'     => 23,
  'white'    => 24,
);

init_pair(1, COLOR_BLACK,   COLOR_WHITE);
init_pair(2, COLOR_RED,     COLOR_BLACK);
init_pair(3, COLOR_BLUE,    COLOR_BLACK);
init_pair(4, COLOR_MAGENTA, COLOR_BLACK);
init_pair(5, COLOR_GREEN,   COLOR_BLACK);
init_pair(6, COLOR_YELLOW,  COLOR_BLACK);
init_pair(7, COLOR_CYAN,    COLOR_BLACK);
init_pair(8, COLOR_WHITE,   COLOR_BLACK);

$::old_color = 'grey';

sub color
{
  my $fg = shift;
  my $bg = shift;
  attroff(A_BOLD) if $::colormap{$::old_color} > 10;
  attroff(COLOR_PAIR($::colormap{$::old_color} % 16));
  attron(A_BOLD) if $::colormap{$fg} > 10;
  attron(COLOR_PAIR($::colormap{$fg} % 16));
  $::old_color = $fg;
}

1;
