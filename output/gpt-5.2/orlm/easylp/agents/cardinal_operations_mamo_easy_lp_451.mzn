% Parameters
int: fertilizer_min = 0;          % Minimum allowed Fertilizer units
int: fertilizer_max = 100;        % Maximum allowed Fertilizer units
int: pesticide_min  = 0;          % Minimum allowed Pesticide units
int: pesticide_max  = 60;         % Maximum allowed Pesticide units

int: min_total_units = 50;        % At least this many units combined (F + P)
int: max_weighted_units = 120;    % Upper limit on (2*F + P)
int: fertilizer_minus_pesticide_min = 10; % Fertilizer must be at least 10 more than Pesticide

int: cost_fertilizer = 2;         % Cost per unit Fertilizer ($)
int: cost_pesticide  = 3;         % Cost per unit Pesticide ($)

% Variables
var fertilizer_min..fertilizer_max: Fertilizer;  % Units of Fertilizer (integer)
var pesticide_min..pesticide_max:   Pesticide;   % Units of Pesticide (integer)

% Total cost upper bound based on max possible usage within declared domains
var 0..(cost_fertilizer*fertilizer_max + cost_pesticide*pesticide_max): TotalCost;

% Constraints
% Minimum combined units requirement (Fertilizer + Pesticide)
constraint
  Fertilizer + Pesticide >= min_total_units;

% Environmental/regulatory upper bound on weighted usage (2*Fertilizer + Pesticide)
constraint
  2 * Fertilizer + Pesticide <= max_weighted_units;

% Balance constraint: Fertilizer must exceed Pesticide by at least a fixed margin
constraint
  Fertilizer - Pesticide >= fertilizer_minus_pesticide_min;

% Define total cost based on per-unit costs
constraint
  TotalCost = cost_fertilizer * Fertilizer + cost_pesticide * Pesticide;

% Objective
solve minimize TotalCost;

output [
  "Fertilizer=", show(Fertilizer), "\n",
  "Pesticide=", show(Pesticide), "\n",
  "MinTotalCost=", show(TotalCost), "\n"
];