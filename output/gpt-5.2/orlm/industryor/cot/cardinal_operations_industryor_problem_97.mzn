% Parameters (with values embedded)
int: steel_avail = 200;
int: alum_avail  = 300;
int: labor_avail = 300;

int: steel_A = 6;
int: alum_A  = 8;
int: labor_A = 11;
int: profit_A = 5000;

int: steel_B = 12;
int: alum_B  = 20;
int: labor_B = 24;
int: profit_B = 11000;

int: overtime_cost = 100;

% Variables
var 0..steel_avail: xA;                 % units of product A
var 0..steel_avail: xB;                 % units of product B (safe upper bound)
var 0..10000: overtime_hours;           % overtime hours (bounded large enough)

% Constraints
constraint steel_A * xA + steel_B * xB <= steel_avail;
constraint alum_A  * xA + alum_B  * xB <= alum_avail;

% labor can exceed available via overtime
constraint labor_A * xA + labor_B * xB <= labor_avail + overtime_hours;

% Objective
% Maximize net profit = product profit - overtime pay.
% (This also favors minimal overtime when it does not increase net profit.)
var int: net_profit = profit_A * xA + profit_B * xB - overtime_cost * overtime_hours;

solve maximize net_profit;

output [
  "xA=", show(xA), "\n",
  "xB=", show(xB), "\n",
  "overtime_hours=", show(overtime_hours), "\n",
  "net_profit=", show(net_profit), "\n"
];