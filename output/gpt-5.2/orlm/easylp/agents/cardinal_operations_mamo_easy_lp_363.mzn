% Parameters
% Cost per acre for each crop (USD/acre)
int: cost_wheat    = 2;
int: cost_corn     = 3;
int: cost_soybeans = 1;
int: cost_potatoes = 4;

% Constraint thresholds (acres)
int: min_wheat_corn        = 1000;  % wheat + corn >= 1000
int: max_soybeans_potatoes = 800;   % soybeans + potatoes <= 800
int: min_wheat_minus_soy   = 200;   % wheat - soybeans >= 200
int: max_corn_potatoes     = 500;   % corn + potatoes <= 500


% Variables
% Acres planted for each crop (whole acres, non-negative)
var int: acres_wheat;
var int: acres_corn;
var int: acres_soybeans;
var int: acres_potatoes;

% Total planting cost (USD)
var int: total_cost;


% Constraints
% Domain / feasibility constraints (non-negative acreage)
constraint acres_wheat    >= 0;
constraint acres_corn     >= 0;
constraint acres_soybeans >= 0;
constraint acres_potatoes >= 0;

% Agronomic / capacity constraints
constraint acres_wheat + acres_corn >= min_wheat_corn;                 % wheat + corn minimum
constraint acres_soybeans + acres_potatoes <= max_soybeans_potatoes;   % soybeans + potatoes maximum
constraint acres_wheat - acres_soybeans >= min_wheat_minus_soy;        % wheat sufficiently exceeds soybeans
constraint acres_corn + acres_potatoes <= max_corn_potatoes;           % corn + potatoes maximum

% Total cost definition
constraint total_cost =
  cost_wheat    * acres_wheat +
  cost_corn     * acres_corn +
  cost_soybeans * acres_soybeans +
  cost_potatoes * acres_potatoes;


% Objective
solve minimize total_cost;