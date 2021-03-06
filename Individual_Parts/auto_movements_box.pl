#!/usr/bin/perl
#Author: V A Ramesh
#Date: June - 8 - 2016
#Purpose: Moving Cursor All over the term screen

use Curses;
use Data::Printer;
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

my ( $eggX, $eggY, $score, $pkey, $key, @snake, $eggs_eaten );

$pkey = KEY_RIGHT;

init_game();

sub init_game {

    # show_name();
    banner();
    draw_box();
    spawn_food();
    score(0);
    init_snake();
}

move_snake();

# refresh();
# getch();
# napms(2000);
endwin();

sub move_snake {

    while (1) {
        $key = getch();
        if ( $key == -1 ) {
            $key = $pkey;
        } elsif ( $key eq 'q') {
            last;
        }
        elsif ( $pkey == KEY_LEFT && $key == KEY_RIGHT ) {
            next;
        }
        elsif ( $pkey == KEY_RIGHT && $key == KEY_LEFT ) {
            next;
        }
        elsif ( $pkey == KEY_UP && $key == KEY_DOWN ) {
            next;
        }
        elsif ( $pkey == KEY_DOWN && $key == KEY_UP ) {
            next;
        }

        if ( $snake[0][1] + 1 == $endX && $key == KEY_RIGHT ) {
            $snake[0][1] = $startX + 1;
        }
        elsif ( $snake[0][1] - 1 == $startX && $key == KEY_LEFT ) {
            $snake[0][1] = $endX - 1;
        }
        elsif ( $snake[0][0] - 1 == $startY && $key == KEY_UP ) {
            $snake[0][0] = $endY - 1;
        }
        elsif ( $snake[0][0] + 1 == $endY && $key == KEY_DOWN ) {
            $snake[0][0] = $startY + 1;
        }

        if ( $key == KEY_RIGHT ) {
            if ( $snake[0][0] == $eggY && $snake[0][1] == $eggX ) {
                unshift @snake, [ $eggY, $eggX ];
                score( ++$eggs_eaten * 5 );
                spawn_food();
            }
            for my $i ( reverse( 1 .. $#snake ) ) {
                $snake[$i][0] = $snake[ $i - 1 ][0];
                $snake[$i][1] = $snake[ $i - 1 ][1];
            }
            $snake[0][1]++;
        }
        elsif ( $key == KEY_LEFT ) {
            if ( $snake[0][0] == $eggY && $snake[0][1] == $eggX ) {
                unshift @snake, [ $eggY, $eggX ];
                score( ++$eggs_eaten * 5 );
                spawn_food();
            }
            for my $i ( reverse( 1 .. $#snake ) ) {
                $snake[$i][0] = $snake[ $i - 1 ][0];
                $snake[$i][1] = $snake[ $i - 1 ][1];
            }
            $snake[0][1]--;
        }
        elsif ( $key == KEY_UP ) {
            if ( $snake[0][0] == $eggY && $snake[0][1] == $eggX ) {
                unshift @snake, [ $eggY, $eggX ];
                score( ++$eggs_eaten * 5 );
                spawn_food();
            }
            for my $i ( reverse( 1 .. $#snake ) ) {
                $snake[$i][0] = $snake[ $i - 1 ][0];
                $snake[$i][1] = $snake[ $i - 1 ][1];
            }
            $snake[0][0]--;

        }
        elsif ( $key == KEY_DOWN ) {

            if ( $snake[0][0] == $eggY && $snake[0][1] == $eggX ) {
                unshift @snake, [ $eggY, $eggX ];
                score( ++$eggs_eaten * 5 );
                spawn_food();
            }
            for my $i ( reverse( 1 .. $#snake ) ) {
                $snake[$i][0] = $snake[ $i - 1 ][0];
                $snake[$i][1] = $snake[ $i - 1 ][1];
            }
            $snake[0][0]++;
        }
        draw_board();
        score();
        refresh();
        napms(100);
        $pkey = $key;
    }

}

sub draw_board {    #draws, snake and fruits

    for my $y ( $startY + 1 .. $endY - 1 ) {
        for my $x ( $startX + 1 .. $endX - 1 ) {
            move( $y, $x );
            addch(" ");
        }
    }

    move( $eggY, $eggX );
    attron( COLOR_PAIR(1) );
    addch(ACS_DIAMOND);
    attroff( COLOR_PAIR(1) );

    for my $i ( 0 .. $#snake ) {
        move( $snake[$i][0], $snake[$i][1] );
        addch(ACS_BLOCK);
    }

    refresh();
}

sub init_snake {
    my $headX = int( rand( $endX - $startX - 1 ) ) + $startX + 1;
    my $headY = int( rand( $endY - $startY - 1 ) ) + $startY + 1;

    for ( 0 .. 0 ) {
        push( @snake, [ $headY + $_, $headX ] );
    }
}

sub spawn_food {
    $eggX = int( rand( $endX - $startX - 1 ) ) + $startX + 1;
    $eggY = int( rand( $endY - $startY - 1 ) ) + $startY + 1;
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
