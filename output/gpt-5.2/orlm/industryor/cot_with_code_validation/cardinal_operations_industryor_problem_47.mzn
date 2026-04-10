% Parameters
int: t1A = 4;
int: t1B = 6;
int: cap1 = 150;

int: t2A = 3;
int: t2B = 2;
int: cap2 = 70;

int: pA = 300;
int: pB = 450;

int: minProfit = 10000;
int: minA = 10;
int: minB = 15;

int: otCap2 = 30;
int: penA = 20;
int: penB = 25;

% Variables
var minA..(cap1 div t1A): xA;          % regular-time units of A
var minB..(cap1 div t1B): xB;          % regular-time units of B

var 0..otCap2: ot2;                    % overtime hours used in process II

var 0..(otCap2 div t2A): yA;           % overtime units of A on process II
var 0..(otCap2 div t2B): yB;           % overtime units of B on process II

var int: profit;

% Constraints
constraint
  t1A * xA + t1B * xB = cap1;

constraint
  t2A * xA + t2B * xB <= cap2;

constraint
  t2A * yA + t2B * yB = ot2;

constraint
  t2A * (xA + yA) + t2B * (xB + yB) <= cap2 + otCap2;

constraint
  profit = pA * xA + pB * xB + (pA - penA) * yA + (pB - penB) * yB;

constraint
  profit >= minProfit;

% Objective
solve maximize profit;