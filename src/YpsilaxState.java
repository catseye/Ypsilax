/*
 * tc.catseye.worb.YpsilaxState -- Ypsilax for yoob
 */

/*
 * Copyright (c)2011 Cat's Eye Technologies.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *   Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *
 *   Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in
 *   the documentation and/or other materials provided with the
 *   distribution.
 *
 *   Neither the name of Cat's Eye Technologies nor the names of its
 *   contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * A tc.catseye.worb.YpsilaxState tries to implement the semantics of the
 * Ypsilax grid-rewriter, for running under the yoob framework.
 *
 * This class targets version 0.2 of the yoob framework's interface,
 * which isn't released yet, so knowing this doesn't help you much.
 */

package tc.catseye.ypsilax;

import tc.catseye.yoob.Error;
import tc.catseye.yoob.*;

import java.util.List;
import java.util.ArrayList;
import java.util.Set;
import java.util.HashSet;
import java.util.Map;
import java.util.HashMap;
import java.util.Random;
import java.util.Iterator;


class Ypsilax implements Language {
    public String getName() {
        return "Ypsilax";
    }

    public int numPlayfields() {
        return 1;
    }

    public int numTapes() {
        return 0;
    }

    public boolean hasProgramText() {
        return false;
    }

    public boolean hasInput() {
        return false;
    }

    public boolean hasOutput() {
        return false;
    }

    public List<String> exampleProgramNames() {
        ArrayList<String> names = new ArrayList<String>();
        names.add("transform it");
        names.add("classic example");
        names.add("abracadabra");
        names.add("escaped");
        names.add("multisymbol pattern");
        names.add("grow tape");
        names.add("wildcard");
        //names.add("higher-order");
        names.add("self-modifying");
        return names;
    }

    public YpsilaxState loadExampleProgram(int index) {
        String[][] program = {
          {
            "DDDD",
            "",
            "(  )",
            " D* ",
            "",
            "DDDD",
          },
          {
            "(      )  (      )",
            "  #            #",
            "  # ###    ### #",
            "  #            #",
            "",
            "    ###   ###",
            "",
            "    #      #",
            "    #      #",
            "    #    ###",
          },
          {
            "(  )   (  )",
            " AB     BA",
            "ABRACADABRA",
          },
          {
            "*          ",
            "(  )   (  )",
            " AB     BA",
            "ABRACADABRA",
          },
          {
            "(    )",
            " ABBA",
            " ^^  ",
            "ABRACADABRA",
            "^^^^^^^^^^^",
          },
          {
            "(      )",
            " >  -> ",
            " >  -> ",
            " >  -> ",
            "",
            "---->",
            "---->",
            "---->",
          },
          {
            "(   ?)",
            " A?AX",
            "",
            "ABRACADABRA",
            "",
            "...........",
          },/*
          {
            "(       ?) ",
            "",
            "",
            " ?   ?",
            " ----(  )",
            "",
            "",
            "",
            "    -------------",
            "     ABRACADABRA",
            "",
            "",
            "     ABRACADABRA",
          },*/
          {
            "(X   X   )  (X   X   )",
            " (  )(  )    (  )(  )",
            "  AB  BA      BA  AB",
            "",
            "",
            "        (  )",
            "         AB",
            "",
            "",
            "     ABRACADABRA",
          },
        };
        YpsilaxState s = new YpsilaxState();
        s.playfield.load(program[index]);
        return s;
    }

    public YpsilaxState importFromText(String text) {
        YpsilaxState s = new YpsilaxState();
        s.playfield.load(text.split("\\r?\\n"));
        return s;
    }

    public List<String> getAvailableOptionNames() {
        ArrayList<String> names = new ArrayList<String>();
        return names;
    }

    private static final String[][] properties = {
        {"Author", "Chris Pressey"},
        {"Implementer", "Chris Pressey"},
        {"Implementation notes",
         "In this version, patterns detected in the playfield are always within the " +
         "current bounds of the playfield; in other words, even if the pattern contains " +
         "spaces or wildcards, it will not match the assumed-empty space surrounding " +
         "the defined part of the playfield."},
    };

    public String[][] getProperties() {
        return properties;
    }

}

class Rule extends OverlayPlayfield<CharacterElement> {
    private IntegerElement width, height;
    private CharacterElement wildcard;
    private static final IntegerElement TWO = new IntegerElement(2);

    public Rule(Playfield<CharacterElement> p, IntegerElement x, IntegerElement y,
                IntegerElement width, CharacterElement wildcard) {
        super(p, x, y, width, width.divide(TWO));
        this.width = width;
        this.height = width.divide(TWO);
        this.wildcard = wildcard;
    }

    public Rule(Playfield<CharacterElement> p, IntegerElement x, IntegerElement y,
                IntegerElement width, IntegerElement height, CharacterElement wildcard) {
        super(p, x, y, width, height);
        this.width = width;
        this.height = height;
        this.wildcard = wildcard;
    }

    public Rule createMatchSubject() {
        return new Rule(getPlayfield(), getOffsetX(), getOffsetY(),
                        getHeight(), getHeight(), getWildcard());
    }

    public IntegerElement getWidth() {
        return width;
    }

    public IntegerElement getHeight() {
        return height;
    }

    public CharacterElement getWildcard() {
        return wildcard;
    }

    // This should be a method on a Dumper object which takes a Codec.
    public String dump() {
        IntegerElement min_x = getMinX();
        IntegerElement min_y = getMinY();
        IntegerElement max_x = getMaxX();
        IntegerElement max_y = getMaxY();
        IntegerElement x = min_x;
        IntegerElement y = min_y;
        StringBuffer buf = new StringBuffer();

        //System.out.println("(" + getOffsetX() + "," + getOffsetY() + ")_(" + width + "x" + height + ")");
        while (y.compareTo(max_y) <= 0) {
            x = min_x;
            while (x.compareTo(max_x) <= 0) {
                CharacterElement e = get(x, y);
                buf.append(dumpElement(e));
                x = x.succ();
            }
            y = y.succ();
            buf.append("\n");
        }

        return buf.toString();
    }

    public String dumpElement(CharacterElement e) {
        return e.getName();
    }
}

class WildcardMatcher implements Matcher<CharacterElement,CharacterElement> {
    private CharacterElement wildcard;

    public WildcardMatcher(CharacterElement wildcard) {
        this.wildcard = wildcard;
    }

    public boolean match(CharacterElement sought, CharacterElement candidate) {
        if (wildcard != null && sought.getChar() == wildcard.getChar()) {
            return true;
        }
        return candidate.equals(sought);
    }
}

class PlayfieldMatcher<E extends Element> {
    public boolean isMatchAt(Playfield<E> haystack, Playfield<E> needle, Matcher<E,E> m, IntegerElement x, IntegerElement y) {
        IntegerElement width = needle.getMaxX().subtract(needle.getMinX()).succ();
        IntegerElement height = needle.getMaxY().subtract(needle.getMinY()).succ();
      
        if (x.pred().add(width).compareTo(haystack.getMaxX()) > 0 ||
            y.pred().add(height).compareTo(haystack.getMaxY()) > 0) {
            // exceeds the right or bottom edge, so, no
            return false;
        }
        IntegerElement cx, cy, dx, dy;
        for (cx = x, dx = needle.getMinX();
             dx.compareTo(needle.getMaxX()) <= 0;
             cx = cx.succ(), dx = dx.succ()) {
            for (cy = y, dy = needle.getMinY();
                 dy.compareTo(needle.getMinY()) <= 0;
                 cy = cy.succ(), dy = dy.succ()) {
                E soughtElem = needle.get(dx, dy);
                E foundElem = haystack.get(cx, cy);
                //System.out.printf("sought (%s,%s): '%s', found (%s,%s): '%s'\n",
                //     dx, dy, soughtElem.getName(),
                //     cx, cy, foundElem.getName());
                if (m.match(soughtElem, foundElem)) {
                    // add something to the result-list
                } else {
                    return false;
                }
            }
        }
        return true;
    }

    public Set<Position> getAllMatches(Playfield<E> haystack, Playfield<E> needle, Matcher<E,E> matcher) {
        Set<Position> results = new HashSet<Position>();

        IntegerElement haystackWidth = haystack.getMaxX().subtract(haystack.getMinX()).succ();
        IntegerElement haystackHeight = haystack.getMaxY().subtract(haystack.getMinY()).succ();
        IntegerElement needleWidth = needle.getMaxX().subtract(needle.getMinX()).succ();
        IntegerElement needleHeight = needle.getMaxY().subtract(needle.getMinY()).succ();

        if (needleWidth.compareTo(haystackWidth) > 0 || needleHeight.compareTo(haystackHeight) > 0) {
            // thing being sought is larger than the thing seeking in, so, no
            return results;
        }

        IntegerElement xSpan = haystackWidth.subtract(needleWidth).succ();
        IntegerElement ySpan = haystackHeight.subtract(needleHeight).succ();

        IntegerElement x, y;
        for (x = IntegerElement.ZERO; x.compareTo(xSpan) < 0; x = x.succ()) {
            for (y = IntegerElement.ZERO; y.compareTo(ySpan) < 0; y = y.succ()) {
                if (isMatchAt(haystack, needle, matcher, x, y)) {
                    results.add(new Position(x, y));
                } else {
                }
            }
        }
        return results;
    }
}

class YpsilaxPlayfield extends BasicPlayfield<CharacterElement> {
    public YpsilaxPlayfield() {
        super(new CharacterElement(' '));
    }

    public YpsilaxPlayfield clone() {
        YpsilaxPlayfield c = new YpsilaxPlayfield();
        c.copyBackingStoreFrom(this);
        return c;
    }

    public List<Position> match(YpsilaxPlayfield pattern) {
        return null;
    }

    public List<Rule> findAllRules() {
        IntegerElement x, y;
        ArrayList<Rule> rules = new ArrayList<Rule>();

        for (x = (IntegerElement)getMinX(); x.compareTo(getMaxX()) <= 0; x = x.succ()) {
            for (y = (IntegerElement)getMinY(); y.compareTo(getMaxY()) <= 0; y = y.succ()) {
                boolean escaped = (!y.isZero() && get(x, y.pred()).getChar() != ' ');
                if (escaped) continue;
                if (get(x, y).getChar() == '(') {
                    //System.out.println("Found a rule start at " + x + ", " + y);
                    IntegerElement x2 = x;
                    CharacterElement g = get(x2, y);
                    while (g.getChar() != ')' && x2.compareTo(getMaxX()) <= 0) {
                        x2 = x2.succ();
                        g = get(x2, y);
                    }
                    if (g.getChar() != ')') continue;
                    //System.out.println("Found a rule from " + x + "," + y + " to " + x2);
                    CharacterElement w = get(x2.pred(), y);
                    if (w.getChar() == ' ') w = null;
                    Rule r = new Rule(this, x.succ(), y.succ(), (x2.subtract(x)).pred(), w);
                    rules.add(r);
                }
            }
        }

        return rules;
    }

    public List<Position> findAllRuleMatches(Rule r) {
        //System.out.printf("%s", r.dump());
        WildcardMatcher matcher = new WildcardMatcher(r.getWildcard());
        PlayfieldMatcher<CharacterElement> pm = new PlayfieldMatcher<CharacterElement>();
        List<Position> positions = new ArrayList<Position>();
        // We only want to match the LEFT side of the rule, so we do this:
        Rule matchSubject = r.createMatchSubject();
        for (Position p : pm.getAllMatches(this, matchSubject, matcher)) {
            // System.out.println("CONSIDERING (" + p.getX() + "," + p.getY() + ")");
            // Discard all the ones that are at or above the rule
            if (p.getY().compareTo(r.getOffsetY().add(r.getHeight())) >= 0) {
                //System.out.println("(" + p.getX() + "," + p.getY() + ")..." + r.getOffsetY());
                positions.add(p);
            }
        }
        //System.out.println("---");
        return positions;
    }

    /*
     * We assume a match was made at the given position.
     */
    public void applyRule(Rule r, Position p) {
        IntegerElement i, j;

        CharacterElement wildcard = r.getWildcard();
        //System.out.printf("applying at %s: %s", p.toString(), r.dump());
        /* Note that r.getHeight() == width/2 ... */
        for(i = IntegerElement.ZERO; i.compareTo(r.getHeight()) < 0; i = i.succ()) {
            for(j = IntegerElement.ZERO; j.compareTo(r.getHeight()) < 0; j = j.succ()) {
                CharacterElement replacement = r.get(i.add(r.getHeight()), j);
                IntegerElement destX = p.getX().add(i);
                IntegerElement destY = p.getY().add(j);
                //System.out.printf("(%s,%s): [%s] '%s' -> (%s,%s)\n", i, j, wildcard, replacement.getChar(), destX, destY);
                if (wildcard == null || wildcard.getChar() != replacement.getChar()) {
                    set(destX, destY, replacement);
                }
            }
        }
    }
}

public class YpsilaxState implements tc.catseye.yoob.State {
    protected YpsilaxPlayfield playfield;
    protected BasicPlayfieldView view;
    private Random rand;
    private static final Ypsilax language = new Ypsilax();
    private boolean halted = false;

    public YpsilaxState() {
        playfield = new YpsilaxPlayfield();
        view = new BasicPlayfieldView();
        rand = new Random();
    }
    
    public YpsilaxState clone() {
        YpsilaxState c = new YpsilaxState();
        c.playfield = this.playfield.clone();
        return c;
    }

    public Language getLanguage() {
        return language;
    }

    public List<Error> step(World world) {
        ArrayList<Error> errors = new ArrayList<Error>();
        List<Rule> rules = playfield.findAllRules();
        if (rules.size() == 0) {
            // no sense continuing.  halt.
            halted = true;
            return errors;
        }
        //System.out.println("rules: " + rules.size());
        Rule r = rules.get(rand.nextInt(rules.size()));
        List<Position> positions = playfield.findAllRuleMatches(r);
        //System.out.println("matches: " + positions.size());
        if (positions.size() > 0) {
            Position p = positions.get(rand.nextInt(positions.size()));
            playfield.applyRule(r, p);
        }
        return errors;
    }

    public Playfield getPlayfield(int index) {
        return playfield;
    }

    public Tape getTape(int index) {
        return null;
    }

    public String getProgramText() {
        return "";
    }

    public int getProgramPosition() {
        return 0;
    }

    public List<Error> setProgramText(String text) {
        ArrayList<Error> errors = new ArrayList<Error>();
        return errors;
    }

    public View getPlayfieldView(int index) {
        return view;
    }

    public View getTapeView(int index) {
        return null;
    }

    public void setOption(String name, boolean value) {
    }

    public String exportToText() {
        return playfield.dump();
    }

    public boolean needsInput() {
        return false;
    }

    public boolean hasHalted() {
        return halted;
    }
}

