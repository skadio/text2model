% International Wool Company diet problem (all data embedded)

int: G = 3;
int: N = 4;

set of int: Grains = 1..G;
set of int: Nutrients = 1..N;

% nutr[i,j] = units of nutrient j per pound of grain i (A,B,C,D)
array[Grains, Nutrients] of float: nutr =
 [| 20.0, 10.0, 50.0,  6.0
  | 30.0, 10.0, 30.0,  2.5
  | 70.0,  0.0,  0.0, 10.0
 |];

% req[j] = minimum required units per day (A,B,C,D)
array[Nutrients] of float: req = [110.0, 18.0, 90.0, 14.0];

% cost[i] = cents per pound
array[Grains] of float: cost = [41.0, 36.0, 96.0];

% Use a simple safe constant bound to avoid heavy compile-time calculations.
float: UB = 1000.0;

array[Grains] of var 0.0..UB: x; % pounds of each grain per day

var float: total_cost = sum(i in Grains) (cost[i] * x[i]);

constraint forall(j in Nutrients) (
  sum(i in Grains) (nutr[i,j] * x[i]) >= req[j]
);

solve minimize total_cost;

output [
  "min_cost_cents=", show(total_cost), "\n",
  "x=", show(x), "\n"
];