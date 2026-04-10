% Parameters (with values embedded)
int: n_products = 2;

% Resource requirements (hours per unit)
array[1..n_products] of float: assembly_req = [1.0/4.0, 1.0/3.0];
array[1..n_products] of float: testing_req  = [1.0/8.0, 1.0/3.0];

% Costs and revenues ($ per unit)
array[1..n_products] of float: raw_cost     = [1.2, 0.9];
array[1..n_products] of float: market_value = [9.0, 8.0];

% Capacities
float: assembly_regular_cap = 90.0;
float: testing_cap = 80.0;

% Overtime
float: assembly_overtime_cap = 50.0;
float: overtime_cost_per_hour = 9.0;

% Variables
var 0..1000: x1;  % units of product 1
var 0..1000: x2;  % units of product 2
var 0.0..assembly_overtime_cap: overtime_hours;

% Constraints
constraint
  assembly_req[1] * int2float(x1) + assembly_req[2] * int2float(x2)
  <= assembly_regular_cap + overtime_hours;

constraint
  testing_req[1] * int2float(x1) + testing_req[2] * int2float(x2)
  <= testing_cap;

% Objective
var float: profit =
    market_value[1] * int2float(x1) + market_value[2] * int2float(x2)
  - raw_cost[1]     * int2float(x1) - raw_cost[2]     * int2float(x2)
  - overtime_cost_per_hour * overtime_hours;

solve maximize profit;

output [
  "x1=", show(x1), " x2=", show(x2), " overtime_hours=", show(overtime_hours), "\n",
  "profit=", show(profit), "\n",
  "profit_rounded_to_nearest_dollar=", show(round(profit)), "\n"
];