% Parameters
% Sets of items
set of int: PROTEIN = 1..3;
set of int: VEG = 1..5;

% Per-100g protein sources data (grams protein, dollars cost, grams weight)
array[PROTEIN] of int: protein_g_per100 = [23, 20, 8];         % chicken, salmon, tofu
array[PROTEIN] of float: protein_cost_per100 = [3.0, 5.0, 1.5];
int: protein_weight_per100 = 100;

% Vegetable data per 100g pack (grams protein, dollars cost, grams weight)
array[VEG] of float: veg_protein_g_perpack = [2.8, 0.9, 2.9, 1.0, 3.1]; % broccoli, carrots, spinach, bell pepper, mushrooms
array[VEG] of float: veg_cost_perpack = [1.2, 0.8, 1.5, 1.0, 2.0];
int: veg_weight_perpack = 100;

% Constraints limits
float: budget = 20.0;              % dollars
int: max_total_weight_g = 800;     % grams
int: min_veg_types = 3;


% Variables
% Protein quantities in 100g units (can be bought in any quantity -> model as nonnegative integer units)
array[PROTEIN] of var 0..(max_total_weight_g div protein_weight_per100): x_protein_units;

% Vegetable packs (sold in 100g packs -> integer number of packs)
array[VEG] of var 0..(max_total_weight_g div veg_weight_perpack): x_veg_packs;

% Whether a vegetable type is selected (at least one pack)
array[VEG] of var bool: veg_selected;

% Total protein in grams (float because some vegetable protein values are fractional)
var float: total_protein_g;

% Total cost in dollars (float)
var float: total_cost;

% Total weight in grams (int)
var 0..max_total_weight_g: total_weight_g;


% Constraints

% --- Link selection booleans to vegetable pack counts ---
constraint
  forall(v in VEG) (
    veg_selected[v] <-> (x_veg_packs[v] >= 1)
  );

% --- Minimum number of different vegetable types selected ---
constraint
  sum(v in VEG)(bool2int(veg_selected[v])) >= min_veg_types;

% --- Total cost definition (protein units + vegetable packs) ---
constraint
  total_cost =
    sum(p in PROTEIN)(protein_cost_per100[p] * int2float(x_protein_units[p])) +
    sum(v in VEG)(veg_cost_perpack[v] * int2float(x_veg_packs[v]));

% --- Budget limit ---
constraint
  total_cost <= budget;

% --- Total weight definition (in grams) ---
constraint
  total_weight_g =
    sum(p in PROTEIN)(protein_weight_per100 * x_protein_units[p]) +
    sum(v in VEG)(veg_weight_perpack * x_veg_packs[v]);

% --- Maximum total weight limit ---
constraint
  total_weight_g <= max_total_weight_g;

% --- Total protein definition (in grams) ---
constraint
  total_protein_g =
    sum(p in PROTEIN)(int2float(protein_g_per100[p] * x_protein_units[p])) +
    sum(v in VEG)(veg_protein_g_perpack[v] * int2float(x_veg_packs[v]));


% Objective
solve maximize total_protein_g;