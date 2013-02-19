#!/usr/bin/perl -w
# test.pl - test program for Console::Virtual v2.0
# By Chris Pressey, Cat's Eye Technologies.
# This work is in the public domain.

# This line allows us to have the Console directory in the same
# directory as the test script.

BEGIN { use File::Basename; push @INC, dirname($0); }

# uncomment any of these lines to test with other setups
# BEGIN { $Console::Virtual::setup{input} = 'Screen'; $Console::Virtual::setup{display} = 'Screen'; }
# BEGIN { $Console::Virtual::setup{input} = 'POSIX'; $Console::Virtual::setup{display} = 'Tput'; }
# BEGIN { $Console::Virtual::setup{input} = 'Teletype'; $Console::Virtual::setup{display} = 'Teletype'; }

use Console::Virtual 2.0 qw(getkey display gotoxy clrscr clreol
                            normal inverse bold update_display);

clrscr;
gotoxy(10,20);
display("Hello, world!");

gotoxy(20,10);
inverse();
display("Outta sight!");
normal();

# In this example, Console::Virtual's functions have been imported into
# package main.
# Because of this, code which relied on the old package 'vC' still works.

::gotoxy(1,1);
::bold();
::display("Rock on!");
::normal();

# So does explicitly referencing the 'Console::Virtual' package.
# In fact, if you leave out the qw() list on 'use Console::Virtual',
# you'll have to do it this way.

Console::Virtual::gotoxy(3,3);
Console::Virtual::update_display();

# getkey should automatically invoke update_display when appropriate.

display("Press a key: ");
$foo = getkey();
clrscr();
display("You pressed ", $foo, "!");
update_display;

### END of test.pl ###
