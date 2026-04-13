% Parameters
int: fert_min = 0;
int: fert_max = 100;
int: pest_min = 0;
int: pest_max = 60;

int: min_total = 50;          % Fertilizer + Pesticide >= 50
int: max_weighted = 120;      % 2*Fertilizer + Pesticide <= 120
int: min_diff = 10;           % Fertilizer - Pesticide >= 10

int: cost_fert = 2;
int: cost_pest = 3;

% Variables
var fert_min..fert_max: Fertilizer;
var pest_min..pest_max: Pesticide;

var 0..(cost_fert*fert_max + cost_pest*pest_max): TotalCost;

% Constraints
constraint Fertilizer + Pesticide >= min_total;
constraint 2 * Fertilizer + Pesticide <= max_weighted;
constraint Fertilizer - Pesticide >= min_diff;

constraint TotalCost = cost_fert * Fertilizer + cost_pest * Pesticide;

% Objective
solve minimize TotalCost;