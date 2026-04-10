% Parameters (with values embedded)
int: nProducts = 2;
set of int: P = 1..nProducts;

float: cat_available = 20.0;
float: shark_available = 50.0;

array[P] of float: cat_frac = [0.20, 0.35];
array[P] of float: shark_frac = [0.80, 0.65];

array[P] of float: profit_per_kg = [12.0, 15.0];

% Variables
array[P] of var float: x; % kg produced of each mix

% Constraints
constraint forall(p in P)(x[p] >= 0.0);

constraint sum(p in P)(cat_frac[p] * x[p]) <= cat_available;
constraint sum(p in P)(shark_frac[p] * x[p]) <= shark_available;

% Objective
solve maximize sum(p in P)(profit_per_kg[p] * x[p]);