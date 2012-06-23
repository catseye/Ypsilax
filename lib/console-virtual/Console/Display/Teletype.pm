# Console::Display::Teletype.pm - emulate screen under true teletype
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

$buffer = [];
$cursor_x = 1;
$cursor_y = 1;

### SUBS ###

sub display
{
  my ($m) = join('',@_);
  my $i = 0;
  for($i=0;$i<$cursor_x-1;$i++)
  {
    $buffer->[$cursor_y-1][$i] = ' ' if
      not defined $buffer->[$cursor_y-1][$i];
  }
  for($i=0;$i<length($m);$i++)
  {
    $buffer->[$cursor_y-1][$cursor_x-1+$i] = substr($m, $i, 1);
  }
  $cursor_x += length($m);
}
sub clrscr
{
  my $i = 0;
  for($i=0;$i<25;$i++) { $buffer->[$i] = [ ' ' ]; }
  $cursor_x = 1;
  $cursor_y = 1;
}
sub clreol
{
  while($buffer->[$cursor_y-1][$cursor_x])
  {
    pop @{$buffer->[$cursor_y]};
  }
}
sub gotoxy  { ($cursor_x, $cursor_y) = @_; }
sub bold    { } 
sub inverse { }
sub normal  { }
sub update_display
{
  my $i; my $j;
  print chr(12);
  for($i = 0; $i < 25 and defined $buffer->[$i]; $i++)
  {
    for($j = 0; $j < 80 and defined $buffer->[$i][$j]; $j++)
    {
      print $buffer->[$i][$j];
    }
    print "\n";
  }
}

1;

### END of Teletype.pm ###
