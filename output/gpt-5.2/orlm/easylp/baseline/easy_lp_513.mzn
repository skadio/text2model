% Resource allocation for projects X1, X2, X3
% Minimize total cost subject to constraints, with integer allocations.

int: cost1 = 50;
int: cost2 = 75;
int: cost3 = 120;

int: total_cap = 500;

% Constraints coefficients
int: eff1 = 5;
int: eff2 = 10;
int: eff_min = 1000;

% "twice and a half" = 2.5, avoid fractions by multiplying by 2:
% 2 * (2.5*x3 - x1) <= 2*300  => 5*x3 - 2*x1 <= 600
int: diff_cap2 = 600;

% Bounds: not explicitly provided in the text; use natural feasible bounds from total_cap
var 0..total_cap: x1;
var 0..total_cap: x2;
var 0..total_cap: x3;

constraint x1 + x2 + x3 <= total_cap;
constraint eff1*x1 + eff2*x2 >= eff_min;
constraint 5*x3 - 2*x1 <= diff_cap2;

var int: total_cost = cost1*x1 + cost2*x2 + cost3*x3;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "min_total_cost=", show(total_cost), "\n"
];