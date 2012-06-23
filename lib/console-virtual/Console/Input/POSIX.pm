# Console::Input::POSIX.pm - raw input layer for POSIX
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

# Snarfed rather shamelessly from the Perl FAQ on the subject:

BEGIN
{
  use POSIX qw(:termios_h);

  $fd_stdin = fileno(STDIN);

  $term     = POSIX::Termios->new();
  $term->getattr($fd_stdin);
  $oterm     = $term->getlflag();

  $echo     = ECHO | ECHOK | ICANON;
  $noecho   = $oterm & ~$echo;

  sub cbreak
  {
    $term->setlflag($noecho);
    $term->setcc(VTIME, 1);
    $term->setattr($fd_stdin, TCSANOW);
  }

  cbreak; # optimistic
}

sub cooked
{
  $term->setlflag($oterm);
  $term->setcc(VTIME, 0);
  $term->setattr($fd_stdin, TCSANOW);
}

sub getkey
{
  my $key = '';
  # cbreak(); # pessimistic
  sysread(STDIN, $key, 1);
  # cooked(); # pessimistic
  return $key;
}

END
{
  cooked(); # optimistic
}

1;

### END of POSIX.pm ###
