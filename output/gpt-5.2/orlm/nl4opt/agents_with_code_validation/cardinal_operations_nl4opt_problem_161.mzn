% Parameters
int: patties_per_min_gas = 20;          % Patties cooked per minute by one gas grill
int: patties_per_min_elec = 30;         % Patties cooked per minute by one electric grill
int: oil_per_min_gas = 20;              % Cooking oil units used per minute by one gas grill
int: oil_per_min_elec = 25;             % Cooking oil units used per minute by one electric grill
int: min_patties_per_min = 150;         % Minimum required patties per minute
int: max_oil_per_min = 140;             % Maximum allowed cooking oil units per minute

% Upper bounds derived from oil constraint for safe bounded variable declarations
int: max_gas_grills = max_oil_per_min div oil_per_min_gas;     % floor(140/20)=7
int: max_elec_grills = max_oil_per_min div oil_per_min_elec;   % floor(140/25)=5


% Variables
var 0..max_gas_grills: gas_grills;      % Number of gas grills to buy
var 0..max_elec_grills: elec_grills;    % Number of electric grills to buy

var 0..(max_gas_grills + max_elec_grills): total_grills; % Total number of grills (objective helper)


% Constraints

% Total grills definition (objective helper variable)
constraint
  total_grills = gas_grills + elec_grills;

% Production capacity: must cook at least the minimum patties per minute
constraint
  patties_per_min_gas * gas_grills + patties_per_min_elec * elec_grills
  >= min_patties_per_min;

% Oil usage: must not exceed the maximum cooking oil per minute
constraint
  oil_per_min_gas * gas_grills + oil_per_min_elec * elec_grills
  <= max_oil_per_min;

% Taste preference: number of electric grills must be less than number of gas grills
constraint
  elec_grills < gas_grills;


% Objective
solve minimize total_grills;