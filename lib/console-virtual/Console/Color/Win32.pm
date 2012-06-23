# Win32.pm - 16-colour Windows 32-bit Console colour abstraction

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

use Win32::Console;

%::bgcolormap =
(
  'black'    => $BG_BLACK,
  'red'      => $BG_RED,
  'blue'     => $BG_BLUE,
  'purple'   => $BG_MAGENTA,
  'green'    => $BG_GREEN,
  'brown'    => $BG_BROWN,
  'aqua'     => $BG_CYAN,
  'grey'     => $BG_GRAY,
  'pink'     => $BG_LIGHTRED,
  'sky'      => $BG_LIGHTBLUE,
  'magenta'  => $BG_LIGHTMAGENTA,
  'lime'     => $BG_LIGHTGREEN,
  'yellow'   => $BG_YELLOW,
  'cyan'     => $BG_LIGHTCYAN,
  'white'    => $BG_WHITE,
);

%::fgcolormap =
(
  'black'    => $FG_BLACK,
  'red'      => $FG_RED,
  'blue'     => $FG_BLUE,
  'purple'   => $FG_MAGENTA,
  'green'    => $FG_GREEN,
  'brown'    => $FG_BROWN,
  'aqua'     => $FG_CYAN,
  'grey'     => $FG_GRAY,
  'pink'     => $FG_LIGHTRED,
  'sky'      => $FG_LIGHTBLUE,
  'magenta'  => $FG_LIGHTMAGENTA,
  'lime'     => $FG_LIGHTGREEN,
  'yellow'   => $FG_YELLOW,
  'cyan'     => $FG_LIGHTCYAN,
  'white'    => $FG_WHITE,
);

sub color
{
  my $fg = shift;
  my $bg = shift;
  die "Bad color $fg" if not exists $::fgcolormap{$fg};
  die "Bad color $bg" if not exists $::bgcolormap{$bg};
  $::STDOUT->Attr($::fgcolormap{$fg} | $::bgcolormap{$bg});
}

1;
