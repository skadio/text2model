% Production planning with activation costs and minimum batch sizes

%-------------------------
% Parameters (embedded)
%-------------------------
int: nProducts = 3;
set of int: PRODUCTS = 1..nProducts;

int: nDays = 22;

array[PRODUCTS] of int:   max_demand    = [5300, 4500, 5400];   % (100kg units)
array[PRODUCTS] of float: sell_price    = [124.0, 109.0, 115.0];% ($ per 100kg)
array[PRODUCTS] of float: prod_cost     = [73.30, 52.90, 65.40];% ($ per 100kg)
array[PRODUCTS] of int:   quota_per_day = [500, 450, 550];      % (100kg units/day)
array[PRODUCTS] of float: activation_cost = [170000.0, 150000.0, 100000.0];
array[PRODUCTS] of int:   min_batch     = [20, 20, 16];

array[PRODUCTS] of int: max_total_possible =
  [ min(max_demand[p], nDays * quota_per_day[p]) | p in PRODUCTS ];

%-------------------------
% Variables
%-------------------------
array[PRODUCTS] of var int: produce;
array[PRODUCTS] of var bool: active;

% Domain bounds for produce (cannot use p in the type-inst because p is not in scope there)
constraint forall(p in PRODUCTS) (
  0 <= produce[p] /\ produce[p] <= max_total_possible[p]
);

%-------------------------
% Constraints
%-------------------------

% Total available production days (shared capacity across products)
constraint
  sum(p in PRODUCTS) (
    (produce[p] + quota_per_day[p] - 1) div quota_per_day[p]
  ) <= nDays;

% Activation linking: no production unless active
constraint
  forall(p in PRODUCTS) (
    produce[p] <= max_total_possible[p] * bool2int(active[p])
  );

% Minimum batch size if active (otherwise can be zero)
constraint
  forall(p in PRODUCTS) (
    active[p] -> produce[p] >= min_batch[p]
  );

%-------------------------
% Objective: maximize profit (revenue - variable cost - activation)
%-------------------------
solve maximize
  sum(p in PRODUCTS) (
    (sell_price[p] - prod_cost[p]) * int2float(produce[p])
    - activation_cost[p] * int2float(bool2int(active[p]))
  );