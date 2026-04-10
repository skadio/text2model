% Parameters
int: tA1 = 2;
int: tA2 = 3;
int: tB1 = 3;
int: tB2 = 4;
int: cap1 = 16;
int: cap2 = 24;

int: c_per_B = 2;
int: c_sell_cap = 5;
int: c_dispose_cost = 2;

int: profitA = 4;
int: profitB = 10;
int: profitC = 3;

% Variables
var 0..1000: xA;          % units of product A produced/sold
var 0..1000: xB;          % units of product B produced/sold
var 0..1000: cSell;       % units of by-product C sold
var 0..1000: cDispose;    % units of by-product C disposed

% Constraints
constraint
  tA1 * xA + tB1 * xB <= cap1;

constraint
  tA2 * xA + tB2 * xB <= cap2;

constraint
  cSell + cDispose = c_per_B * xB;

constraint
  cSell <= c_sell_cap;

% Objective
solve maximize profitA * xA + profitB * xB + profitC * cSell - c_dispose_cost * cDispose;