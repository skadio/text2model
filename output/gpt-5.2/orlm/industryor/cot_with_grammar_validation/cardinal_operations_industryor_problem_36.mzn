% Parameters
int: t1A = 4;
int: t1B = 6;
int: t2A = 3;
int: t2B = 2;

int: cap1 = 150;
int: cap2 = 70;

int: profitA = 300;
int: profitB = 450;

int: minProfit = 10000;

int: minA = 10;
int: minB = 15;

% Variables
var 0..1000: A;
var 0..1000: B;
var 0..1000000: totalProfit;

% Constraints
constraint A >= minA;
constraint B >= minB;

% Profit requirement p1
constraint totalProfit = profitA * A + profitB * B;
constraint totalProfit >= minProfit;

% Capacity constraints (weekly available time)
% p3: Process I should be exactly 150 hours
constraint t1A * A + t1B * B = cap1;

% p3: Process II should be fully utilized, with potential overtime if necessary
constraint t2A * A + t2B * B >= cap2;

% Objective
solve maximize totalProfit;