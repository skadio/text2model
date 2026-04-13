% Parameters (with values embedded)
int: T = 6; % months July..December
set of int: M = 1..T;

set of int: P = 1..2; % 1=Product I, 2=Product II

array[M] of string: month_name = ["Jul","Aug","Sep","Oct","Nov","Dec"];

% Demand per month (units)
% Product I: Jul-Sep 30000, Oct-Dec 100000
% Product II: Jul-Sep 15000, Oct-Dec 50000
array[P, M] of int: demand =
  array2d(P, M,
    [
      30000, 30000, 30000, 100000, 100000, 100000,   % Product I
      15000, 15000, 15000, 50000,  50000,  50000     % Product II
    ]);

% Unit production costs (yuan/unit): June-Dec rates apply for Jul-Dec
array[P] of float: prod_cost = [4.5, 7.0];

% Monthly combined production capacity (units)
int: cap_prod = 120000;

% Unit volumes (m^3/unit)
array[P] of float: volume = [0.2, 0.4];

% Warehouse capacities and costs
float: wh_cap = 15000.0;        % m^3 factory warehouse capacity
float: wh_cost_in = 1.0;        % yuan per m^3 per month in-house
float: wh_cost_out = 1.5;       % yuan per m^3 per month external

% Initial inventories at beginning of July (units)
array[P] of int: init_inv = [0, 0];

% Big upper bounds for production/inventory (units)
int: max_prod = cap_prod;
int: max_inv  = 200000; % safe upper bound per product-month


% Variables
array[P, M] of var 0..max_prod: prod;     % production units
array[P, M] of var 0..max_inv: inv;       % end-of-month inventory units

array[M] of var 0.0..1.0e9: inv_vol;      % total inventory volume (m^3) end-of-month
array[M] of var 0.0..wh_cap: inv_in;      % volume stored in factory warehouse (m^3)
array[M] of var 0.0..1.0e9: inv_out;      % volume stored externally (m^3)

var float: total_cost;


% Constraints
% Monthly production capacity (combined)
constraint
  forall(t in M) (
    sum(p in P)(prod[p,t]) <= cap_prod
  );

% Inventory balance and demand satisfaction
% inv[p,t] = inv[p,t-1] + prod[p,t] - demand[p,t], with inv>=0 ensures demand met
constraint
  forall(p in P) (
    inv[p,1] = init_inv[p] + prod[p,1] - demand[p,1]
  );

constraint
  forall(p in P, t in 2..T) (
    inv[p,t] = inv[p,t-1] + prod[p,t] - demand[p,t]
  );

% Inventory volume and split between in-house and external
constraint
  forall(t in M) (
    inv_vol[t] = sum(p in P)(volume[p] * int2float(inv[p,t]))
  );

constraint
  forall(t in M) (
    inv_in[t] + inv_out[t] = inv_vol[t]
  );

% In-house warehouse capacity
constraint
  forall(t in M) (
    inv_in[t] <= wh_cap
  );


% Objective
constraint
  total_cost =
    sum(p in P, t in M)(prod_cost[p] * int2float(prod[p,t])) +
    sum(t in M)(wh_cost_in * inv_in[t] + wh_cost_out * inv_out[t]);

solve minimize total_cost;