# Console::Display::Win32.pm - layer for Win32 Console
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

BEGIN
{
  use Win32::Console;
  if (defined $setup{screen_height} or defined $setup{screen_width})
  {
    $STDOUT->Size($setup{screen_width}, $setup{screen_height});
  }
}

### SUBS ###

sub display { $STDOUT->Write(join('',@_)); }
sub clrscr  { $STDOUT->Cls; }
sub clreol  { my ($x, $y) = $STDOUT->Cursor;
              my ($sx, $sy) = $STDOUT->Info;
              $STDOUT->FillAttr($::FG_GRAY | $::BG_BLACK, $sx-$x, $x, $y);
              $STDOUT->FillChar(" ", $sx-$x, $x, $y); }
sub gotoxy  { my ($x, $y) = @_; $STDOUT->Cursor($x-1,$y-1); }
sub bold    { $STDOUT->Attr($::FG_WHITE | $::BG_BLACK); }
sub inverse { $STDOUT->Attr($::FG_BLACK | $::BG_GRAY); }
sub normal  { $STDOUT->Attr($::FG_GRAY  | $::BG_BLACK); }
sub update_display { } # $STDOUT->Cursor(-1, -1, -1, 1); }

1;

### END of Win32.pm ###
