#!/usr/bin/perl
#Author: V A Ramesh
#Date: June - 8 - 2016
#Purpose: Moving Cursor All over the term screen

use Curses;
use strict;

initscr();

#cbreak();
noecho();
keypad(1);
nodelay(1);
curs_set(0);
start_color();

init_pair( 1, COLOR_RED, COLOR_BLACK );

box( ACS_VLINE, ACS_HLINE );

move( 2, 5 );
printw("Enter Left/Right/Up/Down key to move or q to exit ");

getmaxyx( my $max_row, my $max_col );

my $row = my $col = 0;
my $pkey = KEY_RIGHT;    #prev_key
my $i    = 1;

my ( $key, $fX, $fY );

spawn_food();

while ( $key ne "q" ) {

    getyx( $row, $col );
    $key = getch();

    if ( $key == -1 ) {
        $key = $pkey;
    }

    if ( $col == 2 && $key == KEY_LEFT ) {
        next;
    }
    elsif ( $col == $max_col - 1 && $key == KEY_RIGHT ) {
        next;
    }
    elsif ( $row == 1 && $key == KEY_UP ) {
        next;
    }
    elsif ( $row == $max_row - 2 && $key == KEY_DOWN ) {
        next;
    }

    if ( $key == KEY_LEFT ) {
        move( $row, --$col );
        printw(" ");
        move( $row, --$col );
        printw("#");

    }
    elsif ( $key == KEY_RIGHT ) {
        move( $row, --$col );
        printw(" ");
        move( $row, ++$col );
        printw("#");
    }
    elsif ( $key == KEY_UP ) {
        move( $row, --$col );
        printw(" ");
        move( --$row, $col );
        printw("#");
    }
    elsif ( $key == KEY_DOWN ) {
        move( $row, --$col );
        printw(" ");
        move( ++$row, $col );
        printw("#");
    }
    refresh();
    $pkey = $key;
    napms(100);
}

endwin();

sub spawn_food {
    $fX = int( rand( $max_col - 1 ) ) + 1;
    $fY = int( rand( $max_row - 2 ) ) + 1;

    move( $fY, $fX );
    attron( COLOR_PAIR(1) );
    addch(ACS_DIAMOND);
    attroff( COLOR_PAIR(1) );
    move(5, 5);
    refresh();
}
