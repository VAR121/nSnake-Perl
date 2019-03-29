#!/usr/bin/perl

use strict;
use Curses;

initscr();
cbreak();
start_color();
init_pair( 1, COLOR_RED,    COLOR_BLACK );
init_pair( 2, COLOR_GREEN,  COLOR_BLACK );
init_pair( 3, COLOR_WHITE,  COLOR_BLACK );
init_pair( 4, COLOR_YELLOW, COLOR_BLACK );
init_pair( 5, COLOR_BLUE,   COLOR_BLACK );

getmaxyx( my $max_rows, my $max_cols );

sub rand_screen {
    for my $y ( 0 .. $max_rows ) {
        for my $x ( 0 .. $max_cols ) {
            my $ch = chr( int( rand(94) ) + 33 );
            move( $y, $x );
            my $code = int rand(5) + 1;
            attron( COLOR_PAIR($code) );
            addstr("$ch");
            attroff( COLOR_PAIR($code) );
        }
    }
}

for my $i ( 0 .. 4 ) {
    rand_screen();
    refresh();
    for my $j ( 0 .. 4 ) {
        if ( $j % 2 == 0 ) {
            standout();
        }
        move( $max_rows / 2 - 1, $max_cols / 2 - 6 );
        printw("                  ");
        move( $max_rows / 2, $max_cols / 2 - 6 );
        printw("   ANALYZING...   ");
        move( $max_rows / 2 + 1, $max_cols / 2 - 6 );
        printw("                  ");
        if ( $j % 2 == 0 ) {
            standend();
        }
        refresh();
        napms( 200 - $i * 20 );
    }

    # napms(400);
}

sub show_file {
    open( my $in_file, '<', $0 );

    chomp( my @lines = <$in_file> );

    for my $i ( 0 .. $max_rows ) {
        move( $i, 0 );
        my $len  = $max_cols - length( $lines[$i] );
        printw( $lines[$i] . " " x $len );
    }
}

show_file();

# napms(1);
getch();
endwin();
