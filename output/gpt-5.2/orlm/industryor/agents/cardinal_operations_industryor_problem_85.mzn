% Parameters
% Product indices: 1 = Meaties, 2 = Yummies
set of int: PRODUCTS = 1..2;

% Prices ($/pack)
array[PRODUCTS] of float: price_per_pack = [2.80, 2.00];

% Raw material requirements (lbs/pack)
array[PRODUCTS] of float: grains_lbs_per_pack = [2.0, 3.0];
array[PRODUCTS] of float: meat_lbs_per_pack   = [3.0, 1.5];

% Variable mixing/packaging costs ($/pack)
array[PRODUCTS] of float: variable_cost_per_pack = [0.25, 0.20];

% Raw material purchase costs ($/lb)
float: grains_cost_per_lb = 0.20;
float: meat_cost_per_lb   = 0.50;

% Monthly resource limits
float: max_grains_lbs = 400000.0;
float: max_meat_lbs   = 300000.0;

% Special machine capacity for Meaties (packs/month)
int: meaties_capacity_packs = 90000;


% Variables
% Packs produced for each product (nonnegative integer quantities)
array[PRODUCTS] of var int: packs_produced;

% Total pounds of each raw material used (derived decision-dependent quantities)
var float: total_grains_used_lbs;
var float: total_meat_used_lbs;

% Profit ($)
var float: profit;


% Constraints
% --- Nonnegativity of production quantities ---
constraint
  forall(p in PRODUCTS) (
    packs_produced[p] >= 0
  );

% --- Link total raw material usage to production decisions ---
constraint
  total_grains_used_lbs =
    sum(p in PRODUCTS) (grains_lbs_per_pack[p] * int2float(packs_produced[p]));

constraint
  total_meat_used_lbs =
    sum(p in PRODUCTS) (meat_lbs_per_pack[p] * int2float(packs_produced[p]));

% --- Monthly raw material availability limits ---
constraint total_grains_used_lbs <= max_grains_lbs;
constraint total_meat_used_lbs   <= max_meat_lbs;

% --- Special machine capacity limit for Meaties (product 1) ---
constraint packs_produced[1] <= meaties_capacity_packs;

% --- Profit definition (revenue minus variable costs and raw material purchase costs) ---
constraint
  profit =
    sum(p in PRODUCTS) (
      (price_per_pack[p] - variable_cost_per_pack[p]) * int2float(packs_produced[p])
    )
    - grains_cost_per_lb * total_grains_used_lbs
    - meat_cost_per_lb * total_meat_used_lbs;


% Objective
solve maximize profit;