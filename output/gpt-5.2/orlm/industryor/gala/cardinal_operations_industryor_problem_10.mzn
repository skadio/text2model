% Motorcycle production planning (LP-style) modeled as an integer linear program in MiniZinc
% Data are embedded directly as requested.

include "globals.mzn";

%-----------------------------
% Data (from Table 3.2)
%-----------------------------
int: manuf_cap = 120;
int: assem_cap = 80;
int: insp_cap  = 40;

int: cost_manuf = 12;
int: cost_assem = 8;
int: cost_insp  = 10;

int: price_A = 650;
int: price_B = 725;

int: manuf_A = 20;
int: assem_A = 5;
int: insp_A  = 3;

int: manuf_B = 0;
int: assem_B = 7;
int: insp_B  = 6;

int: min_profit = 3000;
int: min_A = 5;

% Upper bounds from capacities (tight, safe bounds)
int: max_x1 = manuf_cap div manuf_A; % 120/20 = 6
int: max_x2 = min(assem_cap div assem_B, insp_cap div insp_B); % min(80/7,40/6)=6

%-----------------------------
% Decision variables
%-----------------------------
var 0..max_x1: x1; % Type A weekly units
var 0..max_x2: x2; % Type B weekly units

% Idle time (hours) in each process (no overtime allowed)
var 0..manuf_cap: idle_manuf;
var 0..assem_cap: idle_assem;
var 0..insp_cap : idle_insp;

% Profit (here: revenue, since no material costs were provided)
var 0..1000000: profit;

%-----------------------------
% Constraints
%-----------------------------
% Capacity constraints with explicit idle variables (idle >= 0 ensures no overtime)
constraint manuf_A * x1 + manuf_B * x2 + idle_manuf = manuf_cap;
constraint assem_A * x1 + assem_B * x2 + idle_assem = assem_cap;
constraint insp_A  * x1 + insp_B  * x2 + idle_insp  = insp_cap;

% Revenue/profit
constraint profit = price_A * x1 + price_B * x2;

% Requirements
constraint profit >= min_profit;
constraint x1 >= min_A;

% Goal p3: minimize weighted idle time (weights proportional to hourly cost)
var 0..1000000: weighted_idle =
  cost_manuf * idle_manuf + cost_assem * idle_assem + cost_insp * idle_insp;

%-----------------------------
% Solve
%-----------------------------
% Primary: maximize profit. Secondary: among max-profit plans, minimize weighted idle.
solve lexicographic [ -profit, weighted_idle ];

%-----------------------------
% Output
%-----------------------------
output [
  "x1 (Type A) = ", show(x1), "\n",
  "x2 (Type B) = ", show(x2), "\n",
  "Profit (Yuan/week) = ", show(profit), "\n",
  "Idle manufacturing (h) = ", show(idle_manuf), "\n",
  "Idle assembly (h) = ", show(idle_assem), "\n",
  "Idle inspection (h) = ", show(idle_insp), "\n",
  "Weighted idle cost = ", show(weighted_idle), "\n"
];