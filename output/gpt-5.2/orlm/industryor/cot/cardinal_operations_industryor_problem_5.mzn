% Parameters (with values embedded)
int: P = 3; % products: 1=I, 2=II, 3=III
int: Q = 4; % quarters

set of int: Products = 1..P;
set of int: Quarters = 1..Q;

array[Products, Quarters] of int: demand =
  array2d(Products, Quarters,
  [ 1500, 1000, 2000, 1200,   % Product I
    1500, 1500, 1200, 1500,   % Product II
    1000, 2000, 1500, 2500 ]  % Product III
  );

array[Products] of int: hours_per_unit = [2, 4, 3];
int: hours_per_quarter = 15000;

array[Products] of int: late_penalty = [20, 20, 10]; % per unit per quarter of delay
int: inv_cost = 5;                                  % per unit per quarter held

array[Products] of int: init_inventory = [0, 0, 0];
array[Products] of int: target_end_inventory = [150, 150, 150];

% Upper bounds for variables
int: max_total_demand = 6700;            % max over products of total quarterly demand
int: max_prod_per_q = hours_per_quarter; % coarse bound, units are bounded further by hours constraints
int: max_inv = max_total_demand + 150;
int: max_back = max_total_demand;

% Variables
array[Products, Quarters] of var 0..max_prod_per_q: prod;      % production in quarter q
array[Products, Quarters] of var 0..max_inv: inv;              % end-of-quarter inventory
array[Products, Quarters] of var 0..max_back: back;            % end-of-quarter backorder (late deliveries)

% Constraints
% Equipment change: product I cannot be produced in quarter 2
constraint prod[1,2] = 0;

% Capacity per quarter (production hours)
constraint
  forall(q in Quarters) (
    sum(p in Products)(hours_per_unit[p] * prod[p,q]) <= hours_per_quarter
  );

% Inventory / backorder flow using net stock S = inv - back
% Let S[p,q] = S[p,q-1] + prod[p,q] - demand[p,q], with S[p,q] represented by inv/back
constraint
  forall(p in Products, q in Quarters) (
    (inv[p,q] - back[p,q]) =
      (if q = 1 then init_inventory[p] else (inv[p,q-1] - back[p,q-1]) endif)
      + prod[p,q] - demand[p,q]
  );

% End-of-year inventory requirement (end of quarter 4), and no outstanding backorders
constraint
  forall(p in Products) (
    inv[p,4] >= target_end_inventory[p] /\ back[p,4] = 0
  );

% Objective
% Holding cost: inv_cost per unit per quarter on end-of-quarter inventory
% Late compensation: late_penalty per unit per quarter on end-of-quarter backorders
var int: total_cost =
  sum(p in Products, q in Quarters)(inv_cost * inv[p,q] + late_penalty[p] * back[p,q]);

solve minimize total_cost;