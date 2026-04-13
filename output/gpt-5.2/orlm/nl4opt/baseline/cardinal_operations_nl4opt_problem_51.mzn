% Forest Paper production planning (LP as MIP with scaling to avoid decimals)

% Decision variables:
% g = reams of graph paper
% m = reams of music paper
var int: g >= 0;
var int: m >= 0;

% Data (minutes per ream)
float: print_g = 3.0;
float: scan_g  = 5.5;
float: print_m = 1.5;
float: scan_m  = 3.0;

% Machine availability (minutes/day)
int: cap_print = 350;
int: cap_scan  = 350;

% Profit per ream ($)
float: profit_g = 4.0;
float: profit_m = 2.5;

% Scale all constraints/profit by 2 to eliminate halves:
% Printing: 3g + 1.5m <= 350  ->  6g + 3m <= 700
% Scanning: 5.5g + 3m <= 350 -> 11g + 6m <= 700
constraint 6*g + 3*m <= 700;
constraint 11*g + 6*m <= 700;

% Objective: maximize profit
% 4g + 2.5m  -> scaled by 2: 8g + 5m
var int: profit2 = 8*g + 5*m;

solve maximize profit2;

output [
  "Graph reams (g) = ", show(g), "\n",
  "Music reams (m) = ", show(m), "\n",
  "Max profit ($)  = ", show(profit2 / 2.0), "\n"
];