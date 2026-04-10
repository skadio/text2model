% Production planning with overtime penalty (maximize profit, minimize overtime)

% Data
int: steel_avail = 200;
int: alum_avail  = 300;
int: labor_avail = 300;

int: steel_A = 6;   int: alum_A = 8;   int: labor_A = 11;  int: profit_A = 5000;
int: steel_B = 12;  int: alum_B = 20;  int: labor_B = 24;  int: profit_B = 11000;

int: overtime_cost_per_hour = 100;

% Decision variables (integer production quantities)
var 0..1000: xA;
var 0..1000: xB;

% Resource usage
var 0..1000000: steel_used = steel_A * xA + steel_B * xB;
var 0..1000000: alum_used  = alum_A  * xA + alum_B  * xB;
var 0..1000000: labor_used = labor_A * xA + labor_B * xB;

% Overtime (hours beyond available regular labor)
var 0..1000000: overtime;
constraint overtime >= labor_used - labor_avail;
constraint overtime >= 0;

% Material constraints
constraint steel_used <= steel_avail;
constraint alum_used  <= alum_avail;

% Objective: maximize (profit - overtime cost)
var int: total_profit = profit_A * xA + profit_B * xB;
var int: net_profit = total_profit - overtime_cost_per_hour * overtime;

solve maximize net_profit;

output [
  "xA = ", show(xA), "\n",
  "xB = ", show(xB), "\n",
  "steel_used = ", show(steel_used), " / ", show(steel_avail), "\n",
  "alum_used  = ", show(alum_used),  " / ", show(alum_avail), "\n",
  "labor_used = ", show(labor_used), " (regular ", show(labor_avail), ", overtime ", show(overtime), ")\n",
  "total_profit = ", show(total_profit), "\n",
  "overtime_cost = ", show(overtime_cost_per_hour * overtime), "\n",
  "net_profit = ", show(net_profit), "\n"
];