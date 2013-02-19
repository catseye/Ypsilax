# Console::Virtual.pm - unbuffered-input/addressed-display layer
# version 2.0 (February 2013)

# Copyright (c)2003-2013, Chris Pressey, Cat's Eye Technologies.
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

package Console::Virtual;
BEGIN
{
  use 5;
  use strict qw(subs);
  use Exporter;
  $VERSION = 2.0;
  @ISA = qw(Exporter);
  @EXPORT_OK = qw(&display &clrscr &clreol &gotoxy
                  &bold &inverse &normal
                  &update_display &getkey &color
                  &vsleep);
}

%setup = ();

BEGIN
{
  my $found_curses = 0;      # found Curses.pm?
  my $found_term_screen = 0; # found Term::Screen?
  my $found_posix = 0;       # found POSIX.pm?
  my $found_termcap = 0;     # found $TERM and /etc/termcap?
  foreach my $path (@INC)
  {
    $found_curses = 1 if -r "$path/Curses.pm";
    $found_term_screen = 1 if -r "$path/Term/Screen.pm";
    $found_posix = 1 if -r "$path/POSIX.pm";
  }
  $found_termcap = $ENV{TERM} && -r "/etc/termcap";
  $| = 1;

  # Determine raw input module to use.
  # This can be pre-set by the calling code
  # by modifying %Console::Virtual::setup.

  if (not defined $setup{input})
  {
    if ($found_curses)
    {
      $setup{input} = 'Curses';
    }
    elsif ($^O eq 'MSWin32')
    {
      $setup{input} = 'Win32';
    }
    elsif ($found_term_screen)
    {
      $setup{input} = 'Screen';
    }
    elsif ($found_posix)
    {
      $setup{input} = 'POSIX';
    } else
    {
      warn "Warning! Raw input probably not available on this '$^O' system.\n";
      $setup{input} = 'Teletype';
    }
  }
  require "Console/Input/$setup{input}.pm";

  # Determine screen-addressed output method to use.
  # This can be pre-set by the calling code
  # by modifying %Console::Virtual::setup.

  if (not defined $setup{display})
  {
    if ($found_curses)
    {
      $setup{display} = 'Curses';
    }
    elsif ($^O eq 'MSWin32')
    {
      $setup{display} = 'Win32';
    }
    elsif ($found_term_screen)
    {
      $setup{display} = 'Screen';
    }
    elsif ($found_termcap)
    {
      $setup{display} = 'Tput';
    } else
    {
      warn "Addressable screen must be emulated on this '$^O' system";
      $setup{display} = 'Teletype';
    }
  }
  require "Console/Display/$setup{display}.pm";

  # 2001.01.27 CAP
  # Determine color module to use.
  # This can be pre-set by the calling code
  # by modifying %Console::Virtual::setup.

  if (not defined $setup{color})
  {
    if ($found_curses)
    {
      $setup{color} = 'Curses';
    }
    elsif ($^O eq 'MSWin32')
    {
      $setup{color} = 'Win32';
    }
    elsif ($found_term_screen)
    {
      # $setup{color} = 'Screen';    # TODO! needs to be written
      $setup{color} = 'ANSI16';      # not a very general solution
    }
    else
    {
      $setup{color} = 'Mono';
    }
  }
  require "Console/Color/$setup{color}.pm";
}

# This lets us do sub-second sleeps, if Time::HiRes is available.
my $sleep = sub($) { sleep(shift); };
my $found_time_hires = 0;
foreach my $c (@INC)
{
  $found_time_hires = 1 if -r "$c/Time/HiRes.pm";
}
if ($found_time_hires) {
  require Time::HiRes;
  $sleep = sub($) { Time::HiRes::sleep(shift); };
}
sub vsleep($) {
  &$sleep($_[0]);
}

1;

### END of Virtual.pm ###
