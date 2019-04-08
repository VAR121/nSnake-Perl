#!/usr/bin/perl

use Curses;
use strict;
use utf8;

curs_set(0);
my $x = "\x{1F60D}";
initscr();
move (5, 5);
addch(ACS_LANTERN);
addstring("Hällö, Wörld $x");
refresh();

box(ACS_VLINE, ACS_HLINE);

getch();
endwin();
