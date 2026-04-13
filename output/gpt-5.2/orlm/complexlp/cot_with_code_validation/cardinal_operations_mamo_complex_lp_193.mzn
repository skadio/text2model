% Product mix with overtime assembly (maximize profit)
% All data embedded; integer production quantities; profit rounded to nearest dollar.

int: n_products = 2;
set of int: P = 1..n_products;

array[P] of float: assembly_req = [1.0/4.0, 1.0/3.0];
array[P] of float: testing_req  = [1.0/8.0, 1.0/3.0];
array[P] of float: raw_cost     = [1.2, 0.9];
array[P] of float: market_value = [9.0, 8.0];

float: assembly_regular_cap = 90.0;
float: testing_cap = 80.0;

float: overtime_cap = 50.0;
float: overtime_cost_per_hour = 9.0;

% Upper bounds to keep float linear constraints within solver limits
int: ub1 = floor(min((assembly_regular_cap + overtime_cap) / assembly_req[1],
                     testing_cap / testing_req[1]));
int: ub2 = floor(min((assembly_regular_cap + overtime_cap) / assembly_req[2],
                     testing_cap / testing_req[2]));

array[P] of var 0..(if index_set(P) == 1..2 then [ub1, ub2][P] else 100000 end): x;
% Note: above uses a constant array indexing trick; for P=1..2 it yields [ub1,ub2].

var 0.0..overtime_cap: overtime_hours;

% Constraints
constraint
  sum(p in P)(assembly_req[p] * int2float(x[p])) <= assembly_regular_cap + overtime_hours;

constraint
  sum(p in P)(testing_req[p] * int2float(x[p])) <= testing_cap;

% Objective (float); report rounded-to-nearest-dollar integer
var float: profit =
  sum(p in P)((market_value[p] - raw_cost[p]) * int2float(x[p]))
  - overtime_cost_per_hour * overtime_hours;

solve maximize profit;

output [
  "x1=", show(x[1]), "\n",
  "x2=", show(x[2]), "\n",
  "overtime_hours=", show(overtime_hours), "\n",
  "profit=", show(profit), "\n",
  "profit_rounded_dollars=", show(round(profit)), "\n"
];