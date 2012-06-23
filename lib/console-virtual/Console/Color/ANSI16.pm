# ANSI16.pm - 16-colour-ANSI colour abstraction

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

%::colormap =
(
  'black'    =>  0,
  'red'      =>  1,
  'green'    =>  2,
  'brown'    =>  3,
  'blue'     =>  4,
  'purple'   =>  5,
  'aqua'     =>  6,
  'grey'     =>  7,
  'pink'     =>  1,
  'lime'     =>  2,
  'yellow'   =>  3,
  'sky'      =>  4,
  'magenta'  =>  5,
  'cyan'     =>  6,
  'white'    =>  7,
);

%::intensitymap =
(
  'black'    =>  0,
  'red'      =>  0,
  'blue'     =>  0,
  'purple'   =>  0,
  'green'    =>  0,
  'brown'    =>  0,
  'aqua'     =>  0,
  'grey'     =>  0,
  'pink'     =>  1,
  'sky'      =>  1,
  'magenta'  =>  1,
  'lime'     =>  1,
  'yellow'   =>  1,
  'cyan'     =>  1,
  'white'    =>  1,
);

sub color
{
  my $fg = shift;
  my $bg = shift;
  die "Bad color" if not exists $::colormap{$fg} or not exists $::colormap{$bg};
  print "\e[$::intensitymap{$fg};3$::colormap{$fg};4$::colormap{$bg}m";
}

1;
