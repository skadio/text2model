% Parameters (with values embedded)
int: R = 4; % raw gasolines
int: P = 2; % final products

set of int: RAW = 1..R;
set of int: PROD = 1..P;

array[RAW] of int: oct_raw = [86, 88, 92, 96];
array[RAW] of int: avail_raw = [20000, 15000, 15000, 10000];
array[RAW] of float: cost_raw = [17.0, 18.0, 20.5, 23.0];

% product 1 = regular, product 2 = premium
array[PROD] of int: min_oct_prod = [89, 93];
array[PROD] of int: demand_prod = [35000, 23000];
array[PROD] of float: price_prod = [19.5, 22.0];

% Variables
array[RAW, PROD] of var 0..40000: blend; % barrels of raw i used in product j
array[PROD] of var 0..40000: prod;       % total barrels produced of each product
var float: profit;

% Constraints
constraint
  forall(j in PROD) (
    prod[j] = sum(i in RAW)(blend[i,j])
  );

constraint
  forall(i in RAW) (
    sum(j in PROD)(blend[i,j]) <= avail_raw[i]
  );

constraint
  forall(j in PROD) (
    prod[j] <= demand_prod[j]
  );

% Octane constraints: weighted average >= minimum required
constraint
  forall(j in PROD) (
    sum(i in RAW)(oct_raw[i] * blend[i,j]) >= min_oct_prod[j] * prod[j]
  );

% Objective
constraint
  profit =
    sum(j in PROD)(price_prod[j] * prod[j])
    - sum(i in RAW, j in PROD)(cost_raw[i] * blend[i,j]);

solve maximize profit;