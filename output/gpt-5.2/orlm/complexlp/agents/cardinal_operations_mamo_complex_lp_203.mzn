% Parameters
int: n_raw = 4;                         % number of raw gasolines
set of int: RAW = 1..n_raw;

int: n_prod = 2;                        % number of final products (regular, premium)
set of int: PROD = 1..n_prod;

array[RAW] of int: raw_octane = [86, 88, 92, 96];               % octane rating of each raw gasoline
array[RAW] of int: raw_avail  = [20000, 15000, 15000, 10000];   % daily availability (barrels/day)
array[RAW] of float: raw_cost = [17.0, 18.0, 20.5, 23.0];       % cost per barrel

array[PROD] of int: min_octane = [89, 93];                      % minimum required octane (regular, premium)
array[PROD] of int: demand_max = [35000, 23000];                % maximum daily demand (barrels/day)
array[PROD] of float: sell_price = [19.5, 22.0];                % selling price per barrel

% A safe upper bound on total production (used for variable bounds)
int: total_raw_avail = sum(i in RAW)(raw_avail[i]);

% Variables
array[RAW, PROD] of var 0..total_raw_avail: blend;  % barrels/day of raw i blended into product p
array[PROD] of var 0..total_raw_avail: prod_qty;    % total barrels/day produced of product p

var float: revenue;                                 % total daily revenue
var float: raw_material_cost;                       % total daily raw gasoline cost
var float: profit;                                  % total daily profit

% Constraints

% ------------------------------------------------------------------
% Production quantity definition: total output per product equals sum of blends
% ------------------------------------------------------------------
constraint
  forall(p in PROD)(
    prod_qty[p] = sum(i in RAW)(blend[i,p])
  );

% ------------------------------------------------------------------
% Raw gasoline availability: cannot use more of each raw than available
% ------------------------------------------------------------------
constraint
  forall(i in RAW)(
    sum(p in PROD)(blend[i,p]) <= raw_avail[i]
  );

% ------------------------------------------------------------------
% Demand limits: cannot produce more than maximum demand for each product
% ------------------------------------------------------------------
constraint
  forall(p in PROD)(
    prod_qty[p] <= demand_max[p]
  );

% ------------------------------------------------------------------
% Octane requirements (linearized weighted-average constraint):
% sum_i (octane_i * blend_i,p) >= min_octane_p * total_prod_p
% ------------------------------------------------------------------
constraint
  forall(p in PROD)(
    sum(i in RAW)(raw_octane[i] * blend[i,p]) >= min_octane[p] * prod_qty[p]
  );

% ------------------------------------------------------------------
% Accounting: revenue and raw material cost definitions
% (Use float conversions to avoid type coercion issues)
% ------------------------------------------------------------------
constraint
  revenue =
    sum(p in PROD)(sell_price[p] * int2float(prod_qty[p]));

constraint
  raw_material_cost =
    sum(i in RAW, p in PROD)(raw_cost[i] * int2float(blend[i,p]));

constraint
  profit = revenue - raw_material_cost;

% Objective
solve maximize profit;