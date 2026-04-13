% Solar Oil blending problem (LP)
% Data embedded as requested.

int: R = 4; % raw gasolines
int: P = 2; % products

set of int: RAW = 1..R;
set of int: PROD = 1..P;

array[RAW] of float: oct_raw   = [86.0, 88.0, 92.0, 96.0];
array[RAW] of float: avail_raw = [20000.0, 15000.0, 15000.0, 10000.0];
array[RAW] of float: cost_raw  = [17.0, 18.0, 20.5, 23.0];

% 1 = regular, 2 = premium
array[PROD] of float: oct_min    = [89.0, 93.0];
array[PROD] of float: demand_max = [35000.0, 23000.0];
array[PROD] of float: price_prod = [19.5, 22.0];

% Decision variables (continuous)
array[RAW, PROD] of var float: x;        % barrels of raw r blended into product p
array[PROD] of var float: prod_qty;      % barrels produced of product p
var float: profit;

% Nonnegativity
constraint forall(r in RAW, p in PROD) (x[r,p] >= 0.0);
constraint forall(p in PROD) (prod_qty[p] >= 0.0);

% Product quantities
constraint forall(p in PROD) (
  prod_qty[p] = sum(r in RAW)(x[r,p])
);

% Raw availability
constraint forall(r in RAW) (
  sum(p in PROD)(x[r,p]) <= avail_raw[r]
);

% Demand limits
constraint forall(p in PROD) (
  prod_qty[p] <= demand_max[p]
);

% Octane constraints (linearized weighted-average)
constraint forall(p in PROD) (
  sum(r in RAW)(oct_raw[r] * x[r,p]) >= oct_min[p] * prod_qty[p]
);

% Profit
constraint profit =
  sum(p in PROD)(price_prod[p] * prod_qty[p])
  - sum(r in RAW, p in PROD)(cost_raw[r] * x[r,p]);

solve maximize profit;

output [
  "profit=", show(profit), "\n",
  "regular=", show(prod_qty[1]), " premium=", show(prod_qty[2]), "\n"
];