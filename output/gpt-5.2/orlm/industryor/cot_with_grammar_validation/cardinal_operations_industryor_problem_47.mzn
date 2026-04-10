% Parameters
int: t1A = 4;
int: t1B = 6;
int: cap1 = 150;

int: t2A = 3;
int: t2B = 2;
int: cap2 = 70;

int: profitA = 300;
int: profitB = 450;

int: minProfit = 10000;

int: minA = 10;
int: minB = 15;

int: otMax2 = 30;

int: otPenaltyA = 20;
int: otPenaltyB = 25;

% Variables
var minA..1000: xA;                 % regular-time units of A
var minB..1000: xB;                 % regular-time units of B

var 0..1000: yA;                    % overtime units of A (process II overtime)
var 0..1000: yB;                    % overtime units of B (process II overtime)

var 0..otMax2: ot2;                 % overtime hours used in process II (0..30)

var int: totalProfit;

% Constraints
constraint
  % Process I exactly 150 hours, applies to all produced units
  t1A * (xA + yA) + t1B * (xB + yB) = cap1;

constraint
  % Process II regular capacity + overtime
  t2A * xA + t2B * xB <= cap2;

constraint
  % Overtime hours account exactly for overtime production in process II
  t2A * yA + t2B * yB = ot2;

constraint
  % Total profit with overtime penalties
  totalProfit =
    profitA * xA + profitB * xB
  + (profitA - otPenaltyA) * yA + (profitB - otPenaltyB) * yB;

constraint
  % Minimum weekly profit goal
  totalProfit >= minProfit;

% Objective
solve maximize totalProfit;