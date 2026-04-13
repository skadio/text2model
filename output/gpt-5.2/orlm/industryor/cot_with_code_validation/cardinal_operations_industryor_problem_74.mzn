% Parameters
int: t1A = 2;
int: t2A = 3;
int: t1B = 3;
int: t2B = 4;
int: cap1 = 16;
int: cap2 = 24;

int: profitA = 4;
int: profitB = 10;
int: profitC = 3;

int: c_per_B = 2;
int: C_sell_cap = 5;
int: dispose_cost = 2;

% Upper bounds derived from capacities
int: maxA = min(cap1 div t1A, cap2 div t2A); % <= 8
int: maxB = min(cap1 div t1B, cap2 div t2B); % <= 5
int: maxC = c_per_B * maxB;                  % <= 10

% Variables
var 0..maxA: xA;            % units of product A
var 0..maxB: xB;            % units of product B
var 0..maxC: c_total;       % total by-product C generated
var 0..C_sell_cap: c_sold;  % units of C sold
var 0..maxC: c_disp;        % units of C disposed

% Constraints
constraint t1A * xA + t1B * xB <= cap1;
constraint t2A * xA + t2B * xB <= cap2;

constraint c_total = c_per_B * xB;
constraint c_sold + c_disp = c_total;

% Objective
var int: total_profit = profitA * xA + profitB * xB + profitC * c_sold - dispose_cost * c_disp;

solve maximize total_profit;