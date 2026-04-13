%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Production & inventory planning (July..December) for 2 products
% Minimize production + storage (own + external) costs while meeting demand
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sets
int: T = 6;                 % months July..December
set of int: M = 1..T;
set of int: P = 1..2;       % 1=Product I, 2=Product II

% Demand (units) for Jul..Dec
array[M] of int: demand1 = [30000, 30000, 30000, 100000, 100000, 100000];
array[M] of int: demand2 = [15000, 15000, 15000, 50000, 50000, 50000];
array[P, M] of int: demand = array2d(P, M, [
  demand1[1], demand1[2], demand1[3], demand1[4], demand1[5], demand1[6],
  demand2[1], demand2[2], demand2[3], demand2[4], demand2[5], demand2[6]
]);

% Production costs (yuan/unit) for Jul..Dec (June..December bracket)
array[P, M] of float: prod_cost = array2d(P, M, [
  4.5, 4.5, 4.5, 4.5, 4.5, 4.5,   % Product I
  7.0, 7.0, 7.0, 7.0, 7.0, 7.0    % Product II
]);

% Capacity
int: monthly_capacity = 120000;  % combined units/month

% Volumes and warehouse costs
array[P] of float: volume = [0.2, 0.4]; % m^3 per unit
float: own_wh_cap = 15000.0;           % m^3
float: wh_cost_own = 1.0;              % yuan per m^3 per month
float: wh_cost_ext = 1.5;              % yuan per m^3 per month

% Initial inventory at beginning of July
array[P] of int: init_inv = [0, 0];

% A safe upper bound on inventory volume (m^3)
float: bigM_vol =
  0.2 * int2float(sum(m in M)(demand[1, m])) +
  0.4 * int2float(sum(m in M)(demand[2, m]));

% Variables
array[P, M] of var 0..monthly_capacity: prod;  % units produced
array[P, M] of var int: inv;                    % units end-of-month inventory (>=0 constrained)

array[M] of var 0.0..bigM_vol: inv_vol;         % total inventory volume (m^3)
array[M] of var 0.0..own_wh_cap: own_vol;       % stored in own warehouse (m^3)
array[M] of var 0.0..bigM_vol: ext_vol;         % stored externally (m^3)

var float: total_prod_cost;
var float: total_wh_cost;
var float: total_cost;

% Constraints

% Monthly combined production capacity
constraint forall(m in M)(
  sum(p in P)(prod[p, m]) <= monthly_capacity
);

% Inventory balance and nonnegativity
constraint forall(p in P, m in M)(
  inv[p, m] =
    (if m = 1 then init_inv[p] else inv[p, m-1] endif)
    + prod[p, m] - demand[p, m]
);
constraint forall(p in P, m in M)(inv[p, m] >= 0);

% Inventory volume (convert inv to float with int2float)
constraint forall(m in M)(
  inv_vol[m] = sum(p in P)(volume[p] * int2float(inv[p, m]))
);

% Split inventory volume into own + external storage
constraint forall(m in M)(
  own_vol[m] + ext_vol[m] = inv_vol[m]
);
constraint forall(m in M)(
  own_vol[m] <= own_wh_cap
);

% Objective components
constraint total_prod_cost =
  sum(p in P, m in M)(prod_cost[p, m] * int2float(prod[p, m]));

constraint total_wh_cost =
  sum(m in M)(wh_cost_own * own_vol[m] + wh_cost_ext * ext_vol[m]);

constraint total_cost = total_prod_cost + total_wh_cost;

solve minimize total_cost;

% Optional output
output [
  "Total cost = ", show(total_cost), "\n",
  "Production (rows: product 1..2, cols: Jul..Dec):\n",
  show(prod), "\n",
  "Inventory end-of-month (rows: product 1..2, cols: Jul..Dec):\n",
  show(inv), "\n",
  "Own vol (m^3): ", show(own_vol), "\n",
  "Ext vol (m^3): ", show(ext_vol), "\n"
];