#!/usr/bin/perl
#Author: V A Ramesh
#Date: June - 8 - 2016
#Purpose: Moving Cursor All over the term screen

use Curses;
use strict;

initscr();
cbreak();
noecho();
keypad(1);
nodelay(1);
curs_set(0);
start_color();

init_pair( 1, COLOR_RED,   COLOR_BLACK );
init_pair( 2, COLOR_GREEN, COLOR_BLACK );

getmaxyx( my $max_row, my $max_col );

my $width  = int( $max_col * 0.6 );
my $height = int( $max_row * 0.6 );
my $startY = int( $max_row * 0.2 );
my $startX = int( $max_col * 0.2 );
my $endY   = $startY + $height;
my $endX   = $startX + $width;

my ( $headX, $headY, $eggX, $eggY, $score, $pkey, $key, $snake_len );
my($pX, $pY);


$pkey = KEY_RIGHT;
$snake_len = 5;

init_game();

sub init_game {
    # show_name();
    banner();
    draw_box();
    spawn_food();
    score(0);
    init_snake();
}

move_snake($headY, $headX);

refresh();
getch();
napms(20000);
endwin();

sub move_snake {

    my $headrow = shift;
    my $headcol = shift;

    while (1) {
        $key = getch();
        if ($key == -1) {
            $key = $pkey;
        }

        if ($key == KEY_RIGHT) {
            move($headrow, $headcol);
            addch("*");
            move($headrow, ++$headcol);
            addch(ACS_BLOCK);
            # refresh();
            refresh();
            napms(500);

            $pX = $headcol - 1;
            $pY = $headrow;

            # for my $i (1 .. $snake_len - 1) {
            #     move($pY, $pX);
            #     addch(ACS_BLOCK);
            #     move($pY - 1, $pX);
            #     addch("*");
            #     refresh();
            #     napms(500);
            #     # addch("*");
            # }
        }
    }


}

sub init_snake {
    $headX = int( rand( $endX - $startX - 1 ) ) + $startX + 1;
    $headY = int( rand( $endY - $startY - 1 ) ) + $startY + 1;

    for (reverse 0 .. $snake_len - 1) {
        move($headY - $_, $headX);
        addch(ACS_BLOCK);
    }
    refresh();

}

sub spawn_food {
    $eggX = int( rand( $endX - $startX - 1 ) ) + $startX + 1;
    $eggY = int( rand( $endY - $startY - 1 ) ) + $startY + 1;
    move( $eggY, $eggX );
    attron( COLOR_PAIR(1) );
    addch(ACS_DIAMOND);
    attroff( COLOR_PAIR(1) );
    refresh();
}

sub draw_box {

    for my $x ( $startX .. $endX ) {
        move( $startY, $x );
        addch(ACS_HLINE);
        move( $endY, $x );
        addch(ACS_HLINE);
    }

    for my $y ( $startY .. $endY ) {
        move( $y, $startX );
        addch(ACS_VLINE);
        move( $y, $endX );
        addch(ACS_VLINE);
    }
    move( $startY, $startX );
    addch(ACS_ULCORNER);
    move( $endY, $startX );
    addch(ACS_LLCORNER);

    move( $startY, $endX );
    addch(ACS_URCORNER);
    move( $endY, $endX );
    addch(ACS_LRCORNER);
    refresh();
}

sub score {
    my $s = shift;
    my $x = ( $max_col / 2 ) - 3;    # Center Justify text
    my $y = $endY + 2;
    move( $y, $x );
    printw("Score: $s");
    refresh();
}

sub banner {
    my $x = $max_col / 2 - 7;
    my $y = $startY - 2;
    move( $y, $x );

    attron( COLOR_PAIR(1) );
    printw("Classic Snake!!");
    attroff( COLOR_PAIR(1) );

    attron( COLOR_PAIR(2) );
    move( $y + 1, $x + 5 );
    printw("by R\@M");
    attroff( COLOR_PAIR(2) );
}

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

    for my $i ( 0 .. 10 ) {
        my $startX = $max_col * 0.3;
        my $startY = $max_row * 0.3;
        if ( $i % 2 == 0 ) {
            attron( COLOR_PAIR(1) );
        }
        else {
            attron( COLOR_PAIR(2) );
        }
        for my $j (@name) {
            move( $startY, $startX );
            printw("$j");
            $startY++;
            refresh();
        }
        if ( $i % 2 == 0 ) {
            attroff( COLOR_PAIR(1) );
        }
        else {
            attroff( COLOR_PAIR(2) );
        }
        napms(800);
        move( $startY + 2, $startX + 5 );
        printw("by VARAM");
    }
    clear();
}

# while ( $key ne "q" ) {

#     getyx( $row, $col );
#     $key = getch();

#     if ( $key == -1 ) {
#         $key = $pkey;
#     }

#     if ( $col == 2 && $key == KEY_LEFT ) {
#         next;
#     }
#     elsif ( $col == $max_col - 1 && $key == KEY_RIGHT ) {
#         next;
#     }
#     elsif ( $row == 1 && $key == KEY_UP ) {
#         next;
#     }
#     elsif ( $row == $max_row - 2 && $key == KEY_DOWN ) {
#         next;
#     }

#     if ( $key == KEY_LEFT ) {
#         move( $row, --$col );
#         printw(" ");
#         move( $row, --$col );
#         printw("#");

#     }
#     elsif ( $key == KEY_RIGHT ) {
#         move( $row, --$col );
#         printw(" ");
#         move( $row, ++$col );
#         printw("#");
#     }
#     elsif ( $key == KEY_UP ) {
#         move( $row, --$col );
#         printw(" ");
#         move( --$row, $col );
#         printw("#");
#     }
#     elsif ( $key == KEY_DOWN ) {
#         move( $row, --$col );
#         printw(" ");
#         move( ++$row, $col );
#         printw("#");
#     }
#     refresh();
#     $pkey = $key;
#     napms(100);
# }
