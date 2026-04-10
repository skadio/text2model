include "globals.mzn";

% Dinner planning: maximize protein subject to budget and weight.
% Units:
% - Proteins can be bought in any nonnegative integer number of 100g units.
% - Vegetables are bought in 100g packs; decision is 0/1 for each vegetable.
% - Costs are in cents to keep everything integer.
% - Protein is in tenths of grams (0.1g) to keep everything integer.

%----------------------%
% Data (embedded)      %
%----------------------%
int: budget_cents = 2000;      % $20.00
int: max_weight_g = 800;

% Protein options (per 100g unit)
int: nP = 3;
set of int: P = 1..nP;
array[P] of string: pname = ["chicken","salmon","tofu"];
array[P] of int: p_prot_tenths = [230, 200, 80];  % 23.0g, 20.0g, 8.0g
array[P] of int: p_cost_cents  = [300, 500, 150]; % $3.00, $5.00, $1.50
array[P] of int: p_weight_g    = [100, 100, 100];

% Vegetable options (per 100g pack)
int: nV = 5;
set of int: V = 1..nV;
array[V] of string: vname = ["broccoli","carrots","spinach","bell_pepper","mushrooms"];
array[V] of int: v_prot_tenths = [28, 9, 29, 10, 31];   % 2.8g, 0.9g, 2.9g, 1.0g, 3.1g
array[V] of int: v_cost_cents  = [120, 80, 150, 100, 200];
array[V] of int: v_weight_g    = [100, 100, 100, 100, 100];

% Upper bounds from weight to keep domains tight:
int: maxUnitsAny = max_weight_g div 100; % max number of 100g items total (if everything 100g)

%----------------------%
% Decision variables   %
%----------------------%
array[P] of var 0..maxUnitsAny: p_units;   % number of 100g units of each protein
array[V] of var 0..1: v_take;              % take (1) or not (0) each vegetable pack

%----------------------%
% Constraints          %
%----------------------%
var 0..budget_cents: total_cost =
    sum(i in P)(p_units[i] * p_cost_cents[i]) +
    sum(j in V)(v_take[j] * v_cost_cents[j]);

var 0..max_weight_g: total_weight =
    sum(i in P)(p_units[i] * p_weight_g[i]) +
    sum(j in V)(v_take[j] * v_weight_g[j]);

constraint total_cost <= budget_cents;
constraint total_weight <= max_weight_g;

% Must select at least three different vegetables (types)
constraint sum(j in V)(v_take[j]) >= 3;

%----------------------%
% Objective            %
%----------------------%
var 0..100000: total_protein_tenths =
    sum(i in P)(p_units[i] * p_prot_tenths[i]) +
    sum(j in V)(v_take[j] * v_prot_tenths[j]);

solve maximize total_protein_tenths;

%----------------------%
% Output               %
%----------------------%
output
[
  "Protein units (100g each):\n",
  concat([ "  " ++ pname[i] ++ ": " ++ show(p_units[i]) ++ "\n" | i in P ]),
  "Vegetables (100g packs, 1=selected):\n",
  concat([ "  " ++ vname[j] ++ ": " ++ show(v_take[j]) ++ "\n" | j in V ]),
  "\nTotals:\n",
  "  cost = $" ++ show(total_cost div 100) ++ "." ++
    (if (total_cost mod 100) < 10 then "0" else "" endif) ++ show(total_cost mod 100) ++ "\n",
  "  weight = " ++ show(total_weight) ++ " g\n",
  "  protein = " ++ show(total_protein_tenths div 10) ++ "." ++ show(total_protein_tenths mod 10) ++ " g\n"
];