int: steel_available = 200;
int: aluminum_available = 300;
int: labor_available = 300;

int: steel_A = 6;
int: aluminum_A = 8;
int: labor_A = 11;
int: profit_A = 5000;

int: steel_B = 12;
int: aluminum_B = 20;
int: labor_B = 24;
int: profit_B = 11000;

int: overtime_cost_per_hour = 100;

int: ubA = min(steel_available div steel_A, aluminum_available div aluminum_A);
int: ubB = min(steel_available div steel_B, aluminum_available div aluminum_B);

var 0..ubA: xA;
var 0..ubB: xB;

int: max_total_labor = labor_A * ubA + labor_B * ubB;

var 0..max_total_labor: total_labor_used;
var 0..max_total_labor: overtime_hours;

var int: net_profit;

constraint steel_A * xA + steel_B * xB <= steel_available;
constraint aluminum_A * xA + aluminum_B * xB <= aluminum_available;

constraint total_labor_used = labor_A * xA + labor_B * xB;
constraint overtime_hours >= total_labor_used - labor_available;

constraint net_profit = profit_A * xA + profit_B * xB - overtime_cost_per_hour * overtime_hours;

solve maximize net_profit;

output [
  "xA=", show(xA), "\n",
  "xB=", show(xB), "\n",
  "total_labor_used=", show(total_labor_used), "\n",
  "overtime_hours=", show(overtime_hours), "\n",
  "net_profit=", show(net_profit), "\n"
];