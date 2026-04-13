% Parameters
% Sets of available items
set of int: PROTEINS = 1..3;   % 1=salmon, 2=beef, 3=pork
set of int: VEGS     = 1..4;   % 1=okra, 2=carrots, 3=celery, 4=cabbage

% Nutritional data (fiber grams per 100g of vegetable)
array[VEGS] of float: fiber_per_100g_veg = [3.2, 2.7, 1.6, 2.0];

% Prices ($ per 100g)
array[PROTEINS] of float: price_per_100g_protein = [4.0, 3.6, 1.8];
array[VEGS]     of float: price_per_100g_veg     = [2.6, 1.2, 1.6, 2.3];

% Budget and total intake
float: budget_dollars = 15.0;
int: total_grams = 600;

% Scaling to avoid decimals: work in units of 100g
int: total_units = total_grams div 100;  % 6
constraint total_grams mod 100 = 0;

% Variables
% Amounts purchased in 100g units (nonnegative integers)
array[PROTEINS] of var 0..total_units: protein_units;  % chosen protein amount
array[VEGS]     of var 0..total_units: veg_units;      % vegetable amounts

% Choice indicators
array[PROTEINS] of var 0..1: choose_protein;  % exactly one protein type
array[VEGS]     of var 0..1: choose_veg;      % at least two veg types

% Total fiber intake (grams)
var float: total_fiber;

% Total cost (dollars)
var float: total_cost;

% Constraints
% Total intake must be exactly 600g (i.e., 6 units of 100g)
constraint sum(p in PROTEINS)(protein_units[p]) + sum(v in VEGS)(veg_units[v]) = total_units;

% Exactly one protein type chosen
constraint sum(p in PROTEINS)(choose_protein[p]) = 1;

% Link protein amount to selection
constraint forall(p in PROTEINS)(
  protein_units[p] <= total_units * choose_protein[p]
);

% At least two kinds of vegetables chosen
constraint sum(v in VEGS)(choose_veg[v]) >= 2;

% Link vegetable amount to selection
constraint forall(v in VEGS)(
  veg_units[v] <= total_units * choose_veg[v]
);

% Total cost and budget constraint
constraint total_cost =
  sum(p in PROTEINS)(price_per_100g_protein[p] * int2float(protein_units[p])) +
  sum(v in VEGS)(price_per_100g_veg[v]     * int2float(veg_units[v]));
constraint total_cost <= budget_dollars;

% Total fiber (from vegetables only, as given)
constraint total_fiber =
  sum(v in VEGS)(fiber_per_100g_veg[v] * int2float(veg_units[v]));

% Objective
solve maximize total_fiber;