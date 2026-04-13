% Parameters
int: D = 22;                       % number of production days in the month
int: P = 3;                        % number of products
set of int: PRODUCTS = 1..P;

array[PRODUCTS] of int: max_demand = [5300, 4500, 5400];          % in 100kg units
array[PRODUCTS] of int: price      = [124, 109, 115];             % $ per 100kg
array[PRODUCTS] of float: var_cost = [73.30, 52.90, 65.40];       % $ per 100kg
array[PRODUCTS] of int: quota_day  = [500, 450, 550];             % max 100kg units/day if fully devoted
array[PRODUCTS] of int: act_cost   = [170000, 150000, 100000];    % fixed activation cost ($)
array[PRODUCTS] of int: min_batch  = [20, 20, 16];                % minimum production if activated (100kg units)

% Derived bounds for production quantities
array[PRODUCTS] of int: ub_prod = [ min(max_demand[p], D * quota_day[p]) | p in PRODUCTS ];

% Variables
array[PRODUCTS] of var 0..max(ub_prod): x;   % produced quantity (100kg units)
array[PRODUCTS] of var bool: y;              % 1 if product line is activated, else 0

% Constraints
constraint
  forall(p in PRODUCTS) (
    x[p] <= max_demand[p]
  );

constraint
  forall(p in PRODUCTS) (
    x[p] <= D * quota_day[p]
  );

constraint
  forall(p in PRODUCTS) (
    x[p] <= ub_prod[p] * bool2int(y[p])
  );

constraint
  forall(p in PRODUCTS) (
    x[p] >= min_batch[p] * bool2int(y[p])
  );

% Objective
var float: profit =
  sum(p in PRODUCTS) ( (int2float(price[p]) - var_cost[p]) * int2float(x[p]) )
  - sum(p in PRODUCTS) ( int2float(act_cost[p]) * bool2int(y[p]) );

solve maximize profit;