% Parameters
int: luggage_per_4w = 60;          % Luggage moved per day by one 4-wheeler
int: pollution_per_4w = 30;        % Pollution units per day by one 4-wheeler
int: luggage_per_3w = 40;          % Luggage moved per day by one 3-wheeler
int: pollution_per_3w = 15;        % Pollution units per day by one 3-wheeler
int: min_luggage = 1000;           % Minimum luggage to be moved per day
int: max_pollution = 430;          % Maximum allowed pollution per day

% Upper bounds derived from requirements (safe bounds for search)
int: max_4w = min_luggage div luggage_per_4w + 1;     % enough 4-wheelers to meet luggage alone
int: max_3w = min_luggage div luggage_per_3w + 1;     % enough 3-wheelers to meet luggage alone


% Variables
var 0..max_4w: num_4w;                         % Number of 4-wheeler vehicles to buy
var 0..max_3w: num_3w;                         % Number of 3-wheeler vehicles to buy
var 0..(max_4w + max_3w): total_vehicles;      % Total number of vehicles (objective)


% Constraints

% Total vehicles definition (linking variable)
constraint
  total_vehicles = num_4w + num_3w;

% Luggage capacity requirement: must move at least the minimum luggage per day
constraint
  luggage_per_4w * num_4w + luggage_per_3w * num_3w >= min_luggage;

% Pollution limit requirement: must not exceed the maximum allowed pollution per day
constraint
  pollution_per_4w * num_4w + pollution_per_3w * num_3w <= max_pollution;


% Objective
solve minimize total_vehicles;