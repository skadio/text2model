% Parameters
int: fert_min = 0;             % Minimum units of Fertilizer
int: fert_max = 100;           % Maximum units of Fertilizer
int: pest_min = 0;             % Minimum units of Pesticide
int: pest_max = 60;            % Maximum units of Pesticide

int: min_combined = 50;        % Minimum required combined units (Fertilizer + Pesticide)
int: max_weighted = 120;       % Maximum allowed (2*Fertilizer + Pesticide)
int: fert_minus_pest_min = 10; % Fertilizer must be at least 10 more than Pesticide

int: cost_fert = 2;            % Cost per unit Fertilizer ($)
int: cost_pest = 3;            % Cost per unit Pesticide ($)

% Variables
var fert_min..fert_max: fertilizer;  % Units of Fertilizer (integer)
var pest_min..pest_max: pesticide;   % Units of Pesticide (integer)

var 0..(cost_fert*fert_max + cost_pest*pest_max): total_cost; % Total cost in dollars (integer)

% Constraints
% Link total_cost to decision variables (linear cost accounting)
constraint total_cost = cost_fert * fertilizer + cost_pest * pesticide;

% Minimum combined usage requirement for crop health
constraint fertilizer + pesticide >= min_combined;

% Environmental regulation: weighted combined usage limit
constraint 2 * fertilizer + pesticide <= max_weighted;

% Soil balance: fertilizer must exceed pesticide by at least a fixed margin
constraint fertilizer - pesticide >= fert_minus_pest_min;

% Objective
solve minimize total_cost;