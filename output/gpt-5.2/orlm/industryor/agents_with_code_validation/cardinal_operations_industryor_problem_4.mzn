% Parameters
% Sets of food items
set of int: PROTEINS = 1..3;     % 1=salmon, 2=beef, 3=pork
set of int: VEGETABLES = 1..4;   % 1=okra, 2=carrots, 3=celery, 4=cabbage

% Nutrient content (grams of fiber per 100g)
array[VEGETABLES] of float: fiber_per_100g_veg = [3.2, 2.7, 1.6, 2.0];

% Prices ($ per 100g)
array[PROTEINS] of float: price_per_100g_pro = [4.0, 3.6, 1.8];
array[VEGETABLES] of float: price_per_100g_veg = [2.6, 1.2, 1.6, 2.3];

% Budget and total intake (grams)
float: budget = 15.0;
int: total_grams = 600;

% Minimum number of vegetables to include (distinct types)
int: min_veg_types = 2;

% Helpful bounds for grams (nonnegative and cannot exceed total)
int: grams_lb = 0;
int: grams_ub = total_grams;


% Variables
% Selected protein (exactly one)
array[PROTEINS] of var 0..1: choose_protein;  % 1 if that protein is chosen

% Amounts purchased (grams)
array[PROTEINS] of var grams_lb..grams_ub: grams_protein;     % grams of each protein
array[VEGETABLES] of var grams_lb..grams_ub: grams_vegetable; % grams of each vegetable

% Indicator whether a vegetable type is used (for "at least two kinds")
array[VEGETABLES] of var 0..1: use_vegetable;

% Objective helper: total fiber intake (grams)
var float: total_fiber;

% Objective helper: total cost ($)
var float: total_cost;


% Constraints

% --- Protein selection constraints (choose exactly one protein) ---
constraint
  sum(p in PROTEINS)(choose_protein[p]) = 1;

% Link protein choice to purchased grams (if not chosen => 0g; if chosen => up to total_grams)
constraint
  forall(p in PROTEINS)(
    grams_protein[p] <= total_grams * choose_protein[p]
  );

% Ensure some protein is actually bought (since exactly one is selected, enforce positive grams)
constraint
  sum(p in PROTEINS)(grams_protein[p]) >= 1;

% --- Vegetable usage/type-count constraints (at least min_veg_types distinct vegetables) ---
% Link vegetable usage indicator to grams purchased
constraint
  forall(v in VEGETABLES)(
    grams_vegetable[v] <= total_grams * use_vegetable[v]
  );

% If a vegetable type is marked as used, require at least 1g of it
constraint
  forall(v in VEGETABLES)(
    grams_vegetable[v] >= use_vegetable[v]
  );

% At least two distinct vegetable types are included
constraint
  sum(v in VEGETABLES)(use_vegetable[v]) >= min_veg_types;

% --- Total intake constraint (600g of food in total) ---
constraint
  sum(p in PROTEINS)(grams_protein[p]) + sum(v in VEGETABLES)(grams_vegetable[v]) = total_grams;

% --- Budget / total cost constraints ---
% Define total_cost from chosen quantities and per-100g prices
constraint
  total_cost =
    sum(p in PROTEINS)(price_per_100g_pro[p] * (int2float(grams_protein[p]) / 100.0)) +
    sum(v in VEGETABLES)(price_per_100g_veg[v] * (int2float(grams_vegetable[v]) / 100.0));

% Enforce budget limit
constraint
  total_cost <= budget;

% --- Fiber accounting constraint ---
% Define total_fiber from vegetable quantities and fiber per 100g
constraint
  total_fiber =
    sum(v in VEGETABLES)(fiber_per_100g_veg[v] * (int2float(grams_vegetable[v]) / 100.0));


% Objective
solve maximize total_fiber;