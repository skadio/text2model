% Parameters
int: patties_per_min_gas = 20;          % Patties cooked per minute by one gas grill
int: patties_per_min_electric = 30;     % Patties cooked per minute by one electric grill
int: oil_per_min_gas = 20;              % Cooking oil used per minute by one gas grill
int: oil_per_min_electric = 25;         % Cooking oil used per minute by one electric grill

int: min_patties_per_min = 150;         % Required minimum patties per minute
int: max_oil_per_min = 140;             % Maximum allowed cooking oil per minute

% Upper bounds for search (derived safe bounds from oil limit)
int: max_gas_grills = max_oil_per_min div oil_per_min_gas;             % <= 7
int: max_electric_grills = max_oil_per_min div oil_per_min_electric;   % <= 5


% Variables
var 0..max_gas_grills: num_gas_grills;               % Number of gas grills to buy
var 0..max_electric_grills: num_electric_grills;     % Number of electric grills to buy

var 0..(max_gas_grills + max_electric_grills): total_grills; % Total number of grills


% Constraints
% Link total_grills to the sum of gas and electric grills
constraint total_grills = num_gas_grills + num_electric_grills;

% Production capacity: ensure at least the required patties per minute
constraint
  patties_per_min_gas * num_gas_grills +
  patties_per_min_electric * num_electric_grills
  >= min_patties_per_min;

% Oil usage: ensure cooking oil consumption does not exceed the allowed maximum
constraint
  oil_per_min_gas * num_gas_grills +
  oil_per_min_electric * num_electric_grills
  <= max_oil_per_min;

% Taste preference: number of electric grills must be less than number of gas grills
constraint num_electric_grills < num_gas_grills;


% Objective
solve minimize total_grills;