% Parameters (with values embedded)
int: fert_min = 0;
int: fert_max = 100;
int: pest_min = 0;
int: pest_max = 60;

int: min_total_units = 50;          % Fertilizer + Pesticide >= 50
int: max_weighted_units = 120;      % 2*Fertilizer + Pesticide <= 120
int: fert_excess = 10;              % Fertilizer >= Pesticide + 10

int: cost_fert = 2;                 % $/unit
int: cost_pest = 3;                 % $/unit

% Variables
var fert_min..fert_max: Fertilizer;
var pest_min..pest_max: Pesticide;
var 0..(cost_fert*fert_max + cost_pest*pest_max): TotalCost;

% Constraints
constraint Fertilizer + Pesticide >= min_total_units;
constraint 2 * Fertilizer + Pesticide <= max_weighted_units;
constraint Fertilizer >= Pesticide + fert_excess;

constraint TotalCost = cost_fert * Fertilizer + cost_pest * Pesticide;

% Objective
solve minimize TotalCost;