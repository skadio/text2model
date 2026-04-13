% Microcomputer production (Models A and B) with soft goals / goal-programming weights

% Parameters (embedded data)
int: profitA = 300;
int: profitB = 450;

int: t1A = 4;
int: t1B = 6;
int: cap1 = 150;

int: t2A = 3;
int: t2B = 2;
int: cap2 = 70;

int: minProfit = 10000;
int: minA = 10;
int: minB = 15;

% Safe upper bounds from capacities
int: ubA = min(cap1 div t1A, cap2 div t2A); % = min(37, 23) = 23
int: ubB = min(cap1 div t1B, cap2 div t2B); % = min(25, 35) = 25

% Decision variables
var minA..ubA: A;
var minB..ubB: B;

% Derived quantities
var 0..(profitA*ubA + profitB*ubB): totalProfit;
var 0..cap1: used1;
var 0..(t2A*ubA + t2B*ubB): used2;

% Overtime for process II
var 0..(t2A*ubA + t2B*ubB): overtime2;

% Deviations for goals
var 0..minProfit: profitShortfall;

var 0..cap1: dev1_pos;
var 0..cap1: dev1_neg;

var 0..cap2: under2;

% Constraints
constraint totalProfit = profitA*A + profitB*B;

constraint used1 = t1A*A + t1B*B;
constraint used2 = t2A*A + t2B*B;

% Capacity constraints
constraint used1 <= cap1;
constraint used2 <= cap2 + overtime2;

% Goal p1: profit not less than 10,000 (soft via shortfall)
constraint totalProfit + profitShortfall >= minProfit;

% Goal p3 (I): exactly 150 hours (soft via deviations)
constraint used1 + dev1_neg - dev1_pos = cap1;

% Goal p3 (II): fully utilized regular capacity (no underutilization), allow overtime
constraint used2 + under2 >= cap2;

% Objective with weights (kept within 32-bit int range)
int: W1 = 10000;
int: W2 = 100;
int: W3 = 10;

solve maximize
  ( totalProfit
  - W1 * profitShortfall
  - W2 * (dev1_pos + dev1_neg)
  - W3 * under2
  );

output [
  "A=", show(A), " B=", show(B), "\n",
  "totalProfit=", show(totalProfit), "\n",
  "used1=", show(used1), " used2=", show(used2), "\n",
  "overtime2=", show(overtime2), "\n",
  "profitShortfall=", show(profitShortfall), "\n",
  "dev1_pos=", show(dev1_pos), " dev1_neg=", show(dev1_neg), "\n",
  "under2=", show(under2), "\n"
];