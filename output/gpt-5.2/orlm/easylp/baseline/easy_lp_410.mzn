% Real estate investment optimization (all data embedded)

int: max_total_units = 100;

array[1..4] of int: cost = [5, 7, 3, 4];  % x1..x4
array[1..4] of int: ub   = [40, 50, 30, 20];

% Decision variables: integer investment units in each property type
var 0..ub[1]: x1; % residential
var 0..ub[2]: x2; % commercial
var 0..ub[3]: x3; % industrial
var 0..ub[4]: x4; % recreational

constraint x1 + x2 + x3 + x4 <= max_total_units;

constraint x1 + 4*x2 + x3 + 2*x4 >= 50;

constraint 3*x1 + x2 + 2*x3 + x4 = 75;

var int: total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;

solve minimize total_cost;

output [
  "x1(residential) = ", show(x1), "\n",
  "x2(commercial)  = ", show(x2), "\n",
  "x3(industrial)  = ", show(x3), "\n",
  "x4(recreational)= ", show(x4), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];