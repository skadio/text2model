int: machine_minutes_X = 13;
int: craftsman_minutes_X = 20;
int: machine_minutes_Y = 19;
int: craftsman_minutes_Y = 29;

int: machine_hours_available = 40;
int: craftsman_hours_available = 35;

int: machine_cost_per_hour = 10;
int: craftsman_cost_per_hour = 2;

int: revenue_X = 20;
int: revenue_Y = 30;

int: min_batches_X = 10;

var float: x >= 0.0;
var float: y >= 0.0;

constraint
  (int2float(machine_minutes_X) * x + int2float(machine_minutes_Y) * y) / 60.0
  <= int2float(machine_hours_available);

constraint
  (int2float(craftsman_minutes_X) * x + int2float(craftsman_minutes_Y) * y) / 60.0
  <= int2float(craftsman_hours_available);

constraint x >= int2float(min_batches_X);

var float: profit;

constraint profit =
  int2float(revenue_X) * x + int2float(revenue_Y) * y
  - int2float(machine_cost_per_hour)
    * ((int2float(machine_minutes_X) * x + int2float(machine_minutes_Y) * y) / 60.0)
  - int2float(craftsman_cost_per_hour)
    * ((int2float(craftsman_minutes_X) * x + int2float(craftsman_minutes_Y) * y) / 60.0);

solve maximize profit;

output [
  "x (batches X) = ", show(x), "\n",
  "y (batches Y) = ", show(y), "\n",
  "machine_used_hours = ", show((int2float(machine_minutes_X) * x + int2float(machine_minutes_Y) * y) / 60.0), "\n",
  "craftsman_used_hours = ", show((int2float(craftsman_minutes_X) * x + int2float(craftsman_minutes_Y) * y) / 60.0), "\n",
  "profit = ", show(profit), "\n"
];