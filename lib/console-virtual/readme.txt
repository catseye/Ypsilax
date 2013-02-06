Console::Virtual
----------------

v2007.1122-YPSILAXDEV Chris Pressey, Cat's Eye Technologies.
(c)2003-2007 Cat's Eye Technologies.  All rights reserved.
(BSD-style license.  See file Console/Virtual.pm for full license info.)

What is Console::Virtual?
-------------------------

Console::Virtual is a lightweight, abstract, function-based (as opposed to
object-oriented) Perl interface for accessing unbuffered keyboard input
and an addressable screen display.  Together, these facilities are thought
of as a 'virtual console,' regardless of what underlying technologies
implement it.

Console::Virtual is intended to be only a simple redirection layer that
insulates the programmer from whatever screen-oriented mechanisms are
actually installed at the site.  My experience has been that Curses is often
not installed, or installed incorrectly.  It can be impractical to install,
for any number of reasons.  While Term::Cap and Term::Screen are part of the
Perl 5.8.8 core libraries, they too on occasion are not installed correctly.
Further, they are insufficiently abstract, assuming that the user interacts
with what is essentially a terminal.  Not all systems look at the world this
way -- Windows machines being an obvious example.

Because I was writing a console-based application which was to be highly
portable, I needed a layer which would automatically decide which unbuffered-
input and screen-addressing methods were appropriate for the site, and
provide a small, simple, abstract, portable interface to delegate to those
methods.

Synopsis
--------

To use Console::Virtual, you will either have to install it somewhere in
Perl's include path (you can do this by copying the Console directory and
all of its contents to e.g. /usr/local/lib/perl5/site_perl/5.005), or
alternately, give Perl a new include path which contains the Console
directory.  As usual, there is more than one way to do this: you can
pass the -I flag to the perl executable, or you can add a line like
BEGIN { push @INC, $dir } to your script.  If you want to just keep the
Console directory in the same directory as your script, you can add
BEGIN { use File::Basename; push @INC, dirname($0) } instead.

Then you can insert the following into your Perl script to use it:

  use Console::Virtual 2007.1122
       qw(getkey display gotoxy clrscr clreol
          normal inverse bold color update_display);

Console::Virtual first tries to use Curses, if it's installed.  If not, and
it detects that it's running on a Win32 system, it tries to use
Win32::Console.  If not, it tries using Term::Screen if that's installed.
If not, it then checks to see if POSIX is available, that TERM is set in the
environment, and that /etc/termcap exists; if so, it uses POSIX raw input
and it shells the external command `tput`, buffering the result, for output.

Failing all of that, if Console::Virtual can't find anything that suits your
platform, it will produce a warning, carry on regardless, and assume that it
is running on a teletype.  It will emulate an addressible screen on the
standard output stream the best way it knows how: the entire screen will be
re-printed whenever an update is requested.  Also, the user will have to
tolerate line-buffered input, where a carriage return must be issued before
keystrokes will be responded to.  If this saddens you, be thankful that
teletypes are rare these days.  (There are some of us who are frankly more
saddened *by* the fact that teletypes are rare these days.)

A specific input or display methodology can be specified by setting
values in the %Console::Virtual::setup hash before using Console::Virtual.
You probably shouldn't do this if you want to retain portability; the intent
of it is to allow the end user to tailor their local copy of a script,
forcing it to pick some specific implementation, presumably in preference to
some other which would normally be preferred, but is (for whatever reason)
not desired.  Note that when doing this, you can mix different regimens
for input, display, and color; however, unless you know what you're doing,
you probably shouldn't, as you're likely to get really weird results.
See the code for more details.

Any functions that you don't need to access can be left out of the qw()
list.  In fact, the entire list can be omitted, in which case none of these
names will be imported into your namespace.  In that case, you'll have to
fully qualify them (like Console::Virtual::gotoxy()) to use them.

Input Functions:

  getkey()          wait for keystroke; don't wait for ENTER or echo

Output Functions:

  clrscr()          clear the screen
  clreol()          clear to end of line
  display(@list)    display all strings in @list at screen cursor
  gotoxy($x,$y)     move the cursor to the 1-based (x,y) coordinate
  bold()            set display style to bold
  inverse()         set display style to inverted
  normal()          set display style back to normal
  update_display()  explicitly refresh the screen (Curses & Teletype need this)
  color($f,$b)      sets the colors of text about to be displayed

Acceptable arguments for $f and $b in color() are 'black', 'red', 'blue',
'purple', 'green', 'brown', 'aqua', 'grey', 'pink', 'sky' (blue), 'magenta',
'lime' (green), 'yellow', 'cyan', and 'white'.  Of course, not all terminals
can display this many colors (or any color at all,) in which case color will
be crudely approximated.

Since the library is intended to be simple and abstract, that's all there is;
nothing fancy enough to be severely broken, no capability predicates to check,
no overkill object-oriented interface to follow.

Differences with Term::Screen
-----------------------------

Console::Virtual is designed to be a (portable) abstraction layer, whereas
Term::Screen is not.  There are several 'holes' in the interfaces provided
by Term::Screen; that is, actions which are not prohibited as they probably
ought to be.  In fact, last I checked, they are encouraged.

These actions are prohibited in Console::Virtual.  Specifically, you should
not simply use 'print' to place text on the display device; you must instead
use display().  If you do not do this, the output of your program will look
funny (to say the least) when the end user is using Curses, or a teletype,
or some future output technology that Console::Virtual one day delegates to.
By the same token, you must occasionally use update_display() for the
benefit of Curses and other output regimens which require explicit refresh.
Calling update_display() must be done when the cursor is to be seen, by
the user, to move.  It is also a good idea to do it in anticipation of a
long upcoming delay in the program (e.g. intense computation.)

History
-------

v2001.0123: Renamed this module to _Console::Virtual.
v2001.0124: fixed some namespace issues w.r.t. Win32.
v2001.0127: added Color subfunctionality.
v2003.0325: fixed up test.pl and readme.txt (no changes to code)
v2007.1122: renamed to Console::Virtual, prettied readme.txt.
            Also updated language in BSD license (no "REGENTS".)

More Information
----------------

The latest version of Console::Virtual can be found at:

  http://catseye.webhop.net/projects/cons_virt/

Chris Pressey
November 22, 2007
Chicago, Illinois, USA
