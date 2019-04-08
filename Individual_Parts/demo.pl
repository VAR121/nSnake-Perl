#!/usr/bin/perl

use Curses;
use strict;

initscr();
cbreak();
noecho();
keypad(1);

# nodelay(1);
curs_set(0);
start_color();

getmaxyx( my $max_row, my $max_col );
init_pair( 1, COLOR_RED,   COLOR_BLACK );
init_pair( 2, COLOR_GREEN, COLOR_BLACK );

show_name();

sub show_name {

    my @name = (
        '             ▄▄▄▄                        ▄▄                           ',
        '           ▄█▀▀▀▀█                       ██                           ',
        ' ██▄████▄  ██▄       ██▄████▄   ▄█████▄  ██ ▄██▀    ▄████▄   ▄▄█████▄ ',
        ' ██▀   ██   ▀████▄   ██▀   ██   ▀ ▄▄▄██  ██▄██     ██▄▄▄▄██  ██▄▄▄▄ ▀ ',
        ' ██    ██       ▀██  ██    ██  ▄██▀▀▀██  ██▀██▄    ██▀▀▀▀▀▀   ▀▀▀▀██▄ ',
        ' ██    ██  █▄▄▄▄▄█▀  ██    ██  ██▄▄▄███  ██  ▀█▄   ▀██▄▄▄▄█  █▄▄▄▄▄██ ',
        ' ▀▀    ▀▀   ▀▀▀▀▀    ▀▀    ▀▀   ▀▀▀▀ ▀▀  ▀▀   ▀▀▀    ▀▀▀▀▀    ▀▀▀▀▀▀  ',

    );

    for my $i ( 0 .. 4 ) {
        my $startx = $max_col * 0.3;
        my $starty = $max_row * 0.3;
        if ( $i % 2 == 0 ) {
            attron( COLOR_PAIR(1) );
        }
        else {
            attron( COLOR_PAIR(2) );
        }
        for my $j (@name) {
            move( $starty, $startx );
            printw("$j");
            $starty++;
            refresh();
        }
        if ( $i % 2 == 0 ) {
            attroff( COLOR_PAIR(1) );
        }
        else {
            attroff( COLOR_PAIR(2) );
        }
        napms(800);
        move( $starty + 2, $startx + 5 );
        printw("by VARAM");
    }

    my $key = getch();

    if ( $key eq "q" ) {
        endwin();
        exit;
    }
    else {
        clear();
        move(5, 5);
        printw("Welcome to Game!!");
        refresh();
        napms(3000);
    }
}

refresh();
clear();
getch();
endwin();
