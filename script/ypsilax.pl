#!/usr/bin/perl

# ypsilax.pl - non-deterministic reflective grid-rewriting language
# v2007.1202 Chris Pressey, Cat's Eye Technologies

# Copyright (c)2001-2007, Cat's Eye Technologies.
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

### BEGIN ypsilax.pl ###

use strict qw(vars refs subs);

# This allows us to keep Console::Virtual in same directory as script
BEGIN { use File::Basename; push @INC, dirname($0); }

# Uncomment these lines to use specific display/input/color drivers.
# BEGIN { $Console::Virtual::setup{display} = 'ANSI'; }
# BEGIN { $Console::Virtual::setup{input} = 'Teletype'; }
# BEGIN { $Console::Virtual::setup{color} = 'ANSI16'; }

use Console::Virtual 2007.1122
     qw(getkey display gotoxy clrscr clreol
        normal inverse bold update_display color);

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

### GLOBALS ###

my $maxx = 0;
my $maxy = 0;

### SUBS ###

sub pick_random_rule($)
{
  my $playfield = shift;
  my $x; my $y;
  do
  {
    $x = int(rand(1) * $playfield->{width});
    $y = int(rand(1) * $playfield->{height});
  } until $playfield->{data}[$x][$y] eq '(' and ((not defined($playfield->{data}[$x][$y-1])) or $playfield->{data}[$x][$y-1] eq ' ' or $y == 0);
  my $x2 = $x;
  do { $x2++ } until $playfield->{data}[$x2][$y] eq ')';
  return [$x+1, $y+1, ($x2-$x)-1, int((($x2-$x)-1)/2), $playfield->{data}[$x2-1][$y]];
}

sub apply_rule_randomly($$)
{
  my $playfield = shift;
  my $rule = shift;
  my $x = $rule->[0];
  my $y = $rule->[1];
  my $w = $rule->[2];
  my $h = $rule->[3];
  my $wild = $rule->[4];

  my $dx; my $dy;

  do
  {
    $dx = int(rand(1) * ($playfield->{width})) - $x;
    $dy = int(rand(1) * ($playfield->{height})) - $y;
  } until $dy > 0;

  my $i; my $j;

  my $match = 1;
  for($i = $x; $i < $x + $h; $i++)
  {
    for($j = $y; $j < $y + $h; $j++)
    {
      my $q1 = $playfield->{data}[$i][$j] || ' ';
      my $q2 = $playfield->{data}[$i+$dx][$j+$dy] || ' ';
      if ($q1 eq $wild and $wild ne ' ')
      {
      }
      elsif ($q1 ne $q2)
      {
        $match = 0; last;
      }
    }
  }

  if ($match)
  {
    for($i = $x + $h; $i < $x + $w; $i++)
    {
      for($j = $y; $j < $y + $h; $j++)
      {
        my $q1 = $playfield->{data}[$i][$j];
        if ($q1 eq $wild and $wild ne ' ')
        {
        } else
        {
          $playfield->{data}[$i+$dx-$h][$j+$dy] = $q1;
        }
      }
    }
  }
  return [$match, $x+$dx, $y+$dy];
}

sub load_playfield($)
{
  my $filename = shift;
  my $playfield = {};
  my $line;
  my $x = 0;
  my $y = 0;

  open PLAYFIELD, $filename;
  while(defined($line = <PLAYFIELD>))
  {
    my $i;
    chomp($line);
    for($i = 0; $i < length($line); $i++)
    {
      my $c = substr($line, $i, 1);
      $playfield->{data}[$x][$y] = $c;
      $x++; if ($x > $maxx) { $maxx = $x; }
    }
    $x = 0;
    $y++; if ($y > $maxy) { $maxy = $y; }
  }
  close PLAYFIELD;

  $playfield->{width} = $maxx+1;
  $playfield->{height} = $maxy+1;

  return $playfield;
}

sub draw_playfield
{
  my $playfield = shift;
  my $i; my $j;

  gotoxy(1, 1);
  display("Playfield $playfield->{width} x $playfield->{height}:");

  gotoxy(1, 2);
  for($j = 0; $j <= $maxy; $j++)
  {
    for($i = 0; $i <= $maxx; $i++)
    {
      display($playfield->{data}[$i][$j] || ' ');
    }
    gotoxy(1, $j+3);
  }
}

sub debug($)
{
  #gotoxy(1, 24);
  #display(shift);
}

### MAIN ###

my $playfield;
my $turn = 0;
my $done = 0;
my $delay = 100;

while ($ARGV[0] =~ /^\-\-?(.*?)$/)
{
  my $opt = $1;
  shift @ARGV;
  if ($opt eq 'delay')
  {
    $delay = 0+shift @ARGV;
  }
  else
  {
    die "Unknown command-line option --$opt";
  }
}

clrscr();
color('white', 'black');

srand(time());
my $playfield = load_playfield($ARGV[0]);
draw_playfield($playfield);

while (not $done)
{
  my $rule = pick_random_rule($playfield);
  debug "Found ($rule->[2] X $rule->[3]) rule \@ ($rule->[0], $rule->[1])";
  my $result = apply_rule_randomly($playfield, $rule);
  debug "Matched $result->[0] times \@ ($result->[1], $result->[2])";
  if ($result->[0])
  {
    draw_playfield($playfield);
    update_display();
    &$sleep($delay / 1000);
  }
  debug "$turn reductions... " if ++$turn % 1000 == 0;
}

### END of ypsilax.pl ###
