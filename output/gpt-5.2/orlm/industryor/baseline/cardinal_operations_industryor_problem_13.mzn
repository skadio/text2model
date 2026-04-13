% Dinner planning: maximize total protein under budget and weight, with at least 3 different vegetables.
% All quantities are in 100g units.

include "globals.mzn";

%--------------- Data ---------------
int: budget_cents = 2000;          % $20.00
int: max_weight_units = 8;         % 800g total, in 100g units

% Proteins (continuous availability, but we model as integer number of 100g units)
set of int: P = 1..3;
array[P] of string: pname = ["Chicken", "Salmon", "Tofu"];
array[P] of int: p_protein_deci = [230, 200, 80];   % grams protein per 100g, scaled by 10
array[P] of int: p_cost_cents   = [300, 500, 150];  % cost per 100g in cents

% Vegetables (sold in 100g packs; select packs; must pick at least 3 distinct types)
set of int: V = 1..5;
array[V] of string: vname = ["Broccoli", "Carrots", "Spinach", "BellPepper", "Mushrooms"];
array[V] of int: v_protein_deci = [28, 9, 29, 10, 31];  % grams protein per 100g pack, scaled by 10
array[V] of int: v_cost_cents   = [120, 80, 150, 100, 200];

% Upper bounds from weight limit (at most 8 units total)
int: max_units_each = max_weight_units;

%--------------- Decision variables ---------------
array[P] of var 0..max_units_each: p_units;   % number of 100g portions of each protein
array[V] of var 0..max_units_each: v_packs;   % number of 100g packs of each vegetable
array[V] of var bool: v_used;                 % whether a vegetable type is chosen at least once

%--------------- Constraints ---------------
constraint sum(p_units) + sum(v_packs) <= max_weight_units;

constraint
  sum(p_units[i] * p_cost_cents[i] | i in P) +
  sum(v_packs[j] * v_cost_cents[j] | j in V)
  <= budget_cents;

constraint forall(j in V) (
  v_used[j] <-> (v_packs[j] >= 1)
);

constraint sum(j in V)(bool2int(v_used[j])) >= 3;

%--------------- Objective ---------------
var int: total_protein_deci =
  sum(i in P)(p_units[i] * p_protein_deci[i]) +
  sum(j in V)(v_packs[j] * v_protein_deci[j]);

solve maximize total_protein_deci;

%--------------- Output ---------------
output [
  "Max protein (g): ", show(total_protein_deci / 10.0), "\n",
  "Total weight (g): ", show(100 * (sum(p_units) + sum(v_packs))), "\n",
  "Total cost ($): ",
    show(
      (sum(i in P)(p_units[i] * p_cost_cents[i]) +
       sum(j in V)(v_packs[j] * v_cost_cents[j])) / 100.0
    ), "\n\n",
  "Proteins (100g units):\n",
  concat([ "  " ++ pname[i] ++ ": " ++ show(p_units[i]) ++ "\n" | i in P ]),
  "\nVegetables (100g packs):\n",
  concat([ "  " ++ vname[j] ++ ": " ++ show(v_packs[j]) ++ "\n" | j in V ])
];