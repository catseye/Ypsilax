#!/usr/local/bin/perl

# ypsilax.pl - non-deterministic reflective grid-rewriting language
# v2001.02.19 Chris Pressey, Cat's Eye Technologies

# Copyright (c)2001, Cat's Eye Technologies.
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 
#   Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# 
#   Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in
#   the documentation and/or other materials provided with the
#   distribution.
# 
#   Neither the name of Cat's Eye Technologies nor the names of its
#   contributors may be used to endorse or promote products derived
#   from this software without specific prior written permission. 
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
# CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
# OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE. 

### BEGIN ypsilax.pl ###

$|=1;

sub pick_random_rule
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

sub apply_rule_randomly
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
        $q1 = $playfield->{data}[$i][$j];
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

sub load_playfield
{
  my $filename = shift;
  my $playfield = {};
  my $line;

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
  # print "\e[2J";
  print "Playfield $playfield->{width} x $playfield->{height}:\n";
  for($j = 0; $j <= $maxy; $j++)
  {
    for($i = 0; $i <= $maxx; $i++)
    {
      print $playfield->{data}[$i][$j] || ' ';
    }
    print "\n";
  }
  # print "Press enter: "; <STDIN>;
}

### MAIN ###

srand(time());
$playfield = load_playfield($ARGV[0]);
draw_playfield($playfield);

$turn = 0;
while (not $done)
{
  $rule = pick_random_rule($playfield);
  # print "Found ($rule->[2] X $rule->[3]) rule \@ ($rule->[0], $rule->[1])\n";
  $result = apply_rule_randomly($playfield, $rule);
  # print "Matched $result->[0] times \@ ($result->[1], $result->[2])\n";
  if ($result->[0])
  {
    draw_playfield($playfield);
  }
  print "$turn reductions... " if ++$turn % 1000 == 0;
}

### END of ypsilax.pl ###
