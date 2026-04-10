% Grocery store liquidation: maximize profit from two package types

% Stock availability
int: apples_stock = 10;
int: bananas_stock = 20;
int: grapes_stock = 80;

% Package definitions
% 1) Banana-haters package: 6 apples, 0 bananas, 30 grapes, profit 6
% 2) Combo package:        5 apples, 6 bananas, 20 grapes, profit 7

int: A1 = 6;  int: B1 = 0;  int: G1 = 30; int: P1 = 6;
int: A2 = 5;  int: B2 = 6;  int: G2 = 20; int: P2 = 7;

% Decision variables: quantities of each package
var 0..apples_stock: x1; % banana-haters packages
var 0..apples_stock: x2; % combo packages

% Resource constraints
constraint A1*x1 + A2*x2 <= apples_stock;
constraint B1*x1 + B2*x2 <= bananas_stock;
constraint G1*x1 + G2*x2 <= grapes_stock;

% Objective: maximize profit
var int: profit = P1*x1 + P2*x2;
solve maximize profit;

output [
  "banana_haters_packages = ", show(x1), "\n",
  "combo_packages = ", show(x2), "\n",
  "max_profit = ", show(profit), "\n"
];