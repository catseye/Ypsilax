Ypsilax
=======

Language version 1.1, distribution revision 2014.0525

Overview
--------

**Ypsilax** is a minimal, non-deterministic, reflective, two-dimensional
grid-rewriting language. Ypsilax is a descendent of Zirgulax, which was
an earlier but similar idea which used a hexnet instead of a grid.

An Ypsilax source file is One Big Playfield. This playfield is not
semantically symmetrical; things closer to the 'top' of the playfield
have a higher 'precendence' than the things close to the 'bottom'. (I
experimented with colours and boundaries, and found having a 'sloping'
playfield was much easier to implement.)

[Implementation note. The source for the reference implementation is
only about 5K of Perl code, and much of that is taken up by the
license!]

A rewriting rule in Ypsilax looks like this:

      (  )
       AB

Rules are always twice as wide as they are high. This particular rule,
which is two cells wide by one cell high, says that it is OK to replace
any A found below this rule with a B.

Ypsilax is totally non-determinstic, like [Thue][]. Each reduction
consists of picking a rule by an unspecified method — for all you know,
it is selected completely at random — and attempting to apply it to some
part of the playfield below the rule, again chosen by means unknown.
When this suceeds, that part of the playfield is rewritten.

[Thue]: http://catseye.tc/node/Thue

[Implementation note: in fact, the reference implementation does indeed
select rules and places to apply them using Perl's pseudo-random number
generator. Also, the interpreter dumps an image of the playfield to
`stdout` whenever a rewrite occurs, for some jolly good entertainment,
but this is not specified as part of the language semantics proper.]

Ypsilax is reflective. This means that you can write rules which rewrite
other rules. For example, you could write the following rule above the
previously noted rule, which would rewrite it:

      (        )
       (  )(  )
        AB  CD

Note that this rule is, in fact, four cells high, as it is eight cells
across.

However, there is nothing stopping these 'embedded' rules from also
being randomly picked and applied by some rule that may occur above
them. To get around that we can 'escape' the
rules-to-be-matched-instead-of-obeyed:

      (\   \   )
       (  )(  )
        AB  CD

The backslashes do not affect the semantics of the parentheses as
'define rule'; however they do prevent rewrites on the cells immediately
below them.

Finally, Ypsilax just wouldn't be a proper constraint-based language
without some form of pattern-matching. (*In 1.1: Updated to agree with
existing implementation and examples*) The wildcard character in any
given rule is whatever character appears just to the left of the `)`
that delimits that rule on the right, as long as that character is not
blank space. Whereever this character appears in the left-hand side of
the rule (the pattern,) it will match any character during a rewrite,
not just another of its own kind. Whereever this character appears in
the right-hand side of the rule (the substitution,) it will not replace
the corresponding character in the playfield when a substitution is
made. That character in the playfield will remain unchanged.

License
-------

Copyright ©2001-2014, Chris Pressey, Cat's Eye Technologies.
All rights reserved.

Distributed under a BSD-style license; see `LICENSE` for more information.

Other Implementations
---------------------

There is also a public-domain implementaion of Ypsilax in Java included
in [the yoob distribution](https://github.com/catseye/yoob).
