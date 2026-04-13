% Parameters
% Proteins (can buy any quantity, measured in 100g units)
int: n_proteins = 3;
set of int: PROTEIN = 1..n_proteins;

array[PROTEIN] of string: protein_name = ["chicken", "salmon", "tofu"];
array[PROTEIN] of float: protein_per_100g_protein = [23.0, 20.0, 8.0]; % grams protein per 100g
array[PROTEIN] of float: cost_per_100g_protein = [3.0, 5.0, 1.5];      % $ per 100g
int: grams_per_protein_unit = 100;                                     % grams per unit

% Vegetables (sold in 100g packs)
int: n_vegs = 5;
set of int: VEG = 1..n_vegs;

array[VEG] of string: veg_name =
  ["broccoli", "carrots", "spinach", "bell_pepper", "mushrooms"];
array[VEG] of float: protein_per_pack_veg = [2.8, 0.9, 2.9, 1.0, 3.1]; % grams protein per 100g pack
array[VEG] of float: cost_per_pack_veg = [1.2, 0.8, 1.5, 1.0, 2.0];   % $ per 100g pack
int: grams_per_veg_pack = 100;                                        % grams per pack

% Global constraints
float: budget = 20.0;         % total $
int: max_total_grams = 800;   % max total weight in grams
int: min_distinct_vegs = 3;   % must select at least this many different veg types


% Variables
% Number of 100g units purchased for each protein option (nonnegative integer)
array[PROTEIN] of var 0..(max_total_grams div grams_per_protein_unit): x_protein_units;

% Number of 100g packs purchased for each vegetable (integer >= 0)
array[VEG] of var 0..(max_total_grams div grams_per_veg_pack): x_veg_packs;

% Indicator: whether a vegetable type is chosen (at least 1 pack)
array[VEG] of var bool: veg_chosen;

% Total cost (bounded)
var 0.0..budget: total_cost;

% Total weight in grams (bounded)
var 0..max_total_grams: total_grams;

% Total protein in grams (upper bound based on all 800g being max protein source: chicken 23g/100g)
var 0.0..(23.0 * (max_total_grams / 100.0)): total_protein;


% Constraints

% ----------------------------
% Link veg_chosen to purchases
% ----------------------------
constraint
  forall(v in VEG) (
    veg_chosen[v] <-> (x_veg_packs[v] >= 1)
  );

% ------------------------------------
% At least min_distinct_vegs vegetables
% ------------------------------------
constraint
  sum(v in VEG)(bool2int(veg_chosen[v])) >= min_distinct_vegs;

% ----------------------------
% Define total weight (in grams)
% ----------------------------
constraint
  total_grams =
    grams_per_protein_unit * sum(p in PROTEIN)(x_protein_units[p]) +
    grams_per_veg_pack     * sum(v in VEG)(x_veg_packs[v]);

% ----------------------------
% Weight limit
% ----------------------------
constraint
  total_grams <= max_total_grams;

% ----------------------------
% Define total cost (in $)
% ----------------------------
constraint
  total_cost =
    sum(p in PROTEIN)(cost_per_100g_protein[p] * int2float(x_protein_units[p])) +
    sum(v in VEG)(cost_per_pack_veg[v]         * int2float(x_veg_packs[v]));

% ----------------------------
% Budget limit (also implied by total_cost var bounds, but stated explicitly)
% ----------------------------
constraint
  total_cost <= budget;

% ----------------------------
% Define total protein (in grams)
% ----------------------------
constraint
  total_protein =
    sum(p in PROTEIN)(protein_per_100g_protein[p] * int2float(x_protein_units[p])) +
    sum(v in VEG)(protein_per_pack_veg[v]         * int2float(x_veg_packs[v]));


% Objective
solve maximize total_protein;