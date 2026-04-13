include "globals.mzn";

% ----------------------------
% Data (embedded from statement)
% ----------------------------
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

int: overtime_cost = 100; % yuan per overtime hour

% ----------------------------
% Decision variables
% ----------------------------
var 0..1000000: xA;     % units of product A
var 0..1000000: xB;     % units of product B
var 0..1000000000: overtime; % overtime hours (integer)

% Resource usage
var 0..1000000000: steel_used = steel_A * xA + steel_B * xB;
var 0..1000000000: alum_used  = alum_A  * xA + alum_B  * xB;
var 0..1000000000: labor_used = labor_A * xA + labor_B * xB;

% Profit (net of overtime pay)
var int: gross_profit = profit_A * xA + profit_B * xB;
var int: net_profit   = gross_profit - overtime_cost * overtime;

% ----------------------------
% Constraints
% ----------------------------
constraint steel_used <= steel_avail;
constraint alum_used  <= alum_avail;

% Labor may exceed available hours only via overtime
constraint labor_used <= labor_avail + overtime;

% Tighten overtime to minimum needed for chosen plan
constraint overtime >= labor_used - labor_avail;

% ----------------------------
% Objective: maximize net profit; among ties, minimize overtime
% Achieved by lexicographic optimization using weighted single objective.
% Since 1 overtime hour costs 100 yuan, maximizing net_profit already prefers
% lower overtime when gross_profit is equal. We add an additional small weight
% to break ties by overtime explicitly.
% ----------------------------
int: tie_break = 1; % 1 yuan equivalent tie-break per overtime hour
solve maximize (net_profit * (labor_avail + 1) - overtime * tie_break);

% ----------------------------
% Output
% ----------------------------
output [
  "Units A = ", show(xA), "\n",
  "Units B = ", show(xB), "\n",
  "Steel used = ", show(steel_used), " / ", show(steel_avail), "\n",
  "Aluminum used = ", show(alum_used), " / ", show(alum_avail), "\n",
  "Labor used = ", show(labor_used), " (available ", show(labor_avail), "), overtime = ", show(overtime), "\n",
  "Gross profit = ", show(gross_profit), " yuan\n",
  "Overtime cost = ", show(overtime_cost), " * ", show(overtime), " = ", show(overtime_cost * overtime), " yuan\n",
  "Net profit = ", show(net_profit), " yuan\n"
];