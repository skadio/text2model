% Parameters
int: n = 4;
set of int: S = 1..n;

int: COAL = 1;
int: GAS = 2;
int: WIND = 3;
int: SOLAR = 4;

array[S] of int: cost_cents = [80, 120, 100, 150];   % costs in cents per unit
array[S] of int: cap = [700, 600, 300, 250];         % max units per day

int: min_coal_gas = 500;
int: min_wind_solar = 200;

% Variables
array[S] of var 0..700: x;  % generation units (bounded further by cap below)
var int: total_cost_cents;

% Constraints
constraint forall(i in S) (x[i] <= cap[i]);

constraint x[COAL] + x[GAS] >= min_coal_gas;
constraint x[WIND] + x[SOLAR] >= min_wind_solar;

constraint total_cost_cents = sum(i in S) (cost_cents[i] * x[i]);

% Objective
solve minimize total_cost_cents;

output [
  "coal=", show(x[COAL]), " gas=", show(x[GAS]), " wind=", show(x[WIND]), " solar=", show(x[SOLAR]), "\n",
  "total_cost_cents=", show(total_cost_cents), "\n",
  "total_cost_dollars_rounded=", show( (total_cost_cents + 50) div 100 ), "\n"
];