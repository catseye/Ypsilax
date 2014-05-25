#!/usr/bin/perl

# ypsilax.pl - non-deterministic reflective grid-rewriting language
# v1.1-2014.0525 Chris Pressey, Cat's Eye Technologies

# Copyright (c)2001-2014, Chris Pressey, Cat's Eye Technologies.
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
#use warnings;

# This allows us to keep Console::Virtual in a subrepo located in
# the lib dir of this project
BEGIN
{
  use File::Spec::Functions;
  use File::Basename;
  push @INC, catdir(dirname($0), '..', 'lib', 'console-virtual');
}

# Uncomment these lines to use specific display/input/color drivers.
# BEGIN { $Console::Virtual::setup{display} = 'ANSI'; }
# BEGIN { $Console::Virtual::setup{input} = 'Teletype'; }
# BEGIN { $Console::Virtual::setup{color} = 'ANSI16'; }

use Console::Virtual 2.0
     qw(getkey display gotoxy clrscr clreol
        normal inverse bold update_display color
        vsleep);

### GLOBALS ###

my $usage = "Usage: $0 [--debug] [--delay MSEC] playfield.yps\n";
my $debug = 0;
my $maxx = 0;
my $maxy = 0;

### SUBS ###

sub pick_random_rule($)
{
  my $playfield = shift;
  my $x; my $y; my $tries = 0;
  do
  {
    $x = int(rand(1) * $playfield->{width});
    $y = int(rand(1) * $playfield->{height});
    return undef if ++$tries > 2000;
  } until $playfield->{data}[$x][$y] eq '(' and (
            (not defined($playfield->{data}[$x][$y-1])) or
            $playfield->{data}[$x][$y-1] eq ' ' or
            $y == 0
          );
  my $x2 = $x;
  do { $x2++ } until $playfield->{data}[$x2][$y] eq ')';
  my $wild = $playfield->{data}[$x2-1][$y];
  $wild = ' ' if not defined($wild);
  return [$x+1, $y+1, ($x2-$x)-1, int((($x2-$x)-1)/2), $wild];
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

  my $match = 1;
  for(my $i = $x; $i < $x + $h; $i++)
  {
    for(my $j = $y; $j < $y + $h; $j++)
    {
      my $q1 = $playfield->{data}[$i][$j];
      $q1 = ' ' if not defined($q1);
      my $q2 = $playfield->{data}[$i+$dx][$j+$dy];
      $q2 = ' ' if not defined($q2);
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
    for(my $i = $x + $h; $i < $x + $w; $i++)
    {
      for(my $j = $y; $j < $y + $h; $j++)
      {
        my $q1 = $playfield->{data}[$i][$j];
        $q1 = ' ' if not defined($q1);
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

  open PLAYFIELD, $filename or die "Can't open $filename, stopped";
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
      if (defined $playfield->{data}[$i][$j]) {
        display($playfield->{data}[$i][$j]);
      } else {
        display(' ');
      }
    }
    gotoxy(1, $j+3);
  }
}

sub debug($)
{
  if ($debug) {
    gotoxy(1, 24);
    display(shift);
    clreol;
  }
}

### MAIN ###

my $playfield;
my $turn = 0;
my $done = 0;
my $delay = 100;

while ($ARGV[0] =~ /^\-\-(.*?)$/)
{
  my $opt = $1;
  shift @ARGV;
  if ($opt eq 'delay')
  {
    $delay = 0+shift @ARGV;
  }
  elsif ($opt eq 'debug')
  {
    $debug = 1;
  }
  else
  {
    die $usage . "Unknown command-line option --$opt, stopped";
  }
}

clrscr();
color('white', 'black');

srand(time());
if ($#ARGV != 0) {
  die $usage . "Need exactly one playfield filename, stopped";
}
my $playfield = load_playfield($ARGV[0]);
draw_playfield($playfield);

while (not $done)
{
  my $rule = pick_random_rule($playfield);
  if (defined $rule) {
    debug "Found ($rule->[2] X $rule->[3]) rule \@ ($rule->[0], $rule->[1])";
    my $result = apply_rule_randomly($playfield, $rule);
    debug "Matched $result->[0] times \@ ($result->[1], $result->[2])";
    if ($result->[0] > 0) {
      draw_playfield($playfield);
      update_display();
      vsleep($delay / 1000);
    }
  }
  if (++$turn % 1000 == 0) {
    debug "$turn reductions... ";
    draw_playfield($playfield);
    update_display();
    vsleep($delay / 1000);
  }    
}

### END of ypsilax.pl ###
