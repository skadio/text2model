% Parameters
% Vehicle types (embedded data; no .dzn expected)
set of int: V = 1..2;                 % 1 = 4-wheeler, 2 = 3-wheeler

array[V] of int: capacity = [60, 40]; % luggage moved per vehicle per day
array[V] of int: pollut  = [30, 15];  % pollutant units produced per vehicle per day

int: min_luggage = 1000;              % minimum luggage to move per day
int: max_pollut  = 430;               % maximum pollutant allowed per day

% Safe upper bounds for vehicle counts (derived from pollution limits)
int: max4 = max(0, max_pollut div pollut[1]);  % floor(430/30) = 14
int: max3 = max(0, max_pollut div pollut[2]);  % floor(430/15) = 28


% Variables
var 0..max4: num_4w;                  % number of 4-wheeler vehicles to buy
var 0..max3: num_3w;                  % number of 3-wheeler vehicles to buy

var 0..(max4 + max3): total_vehicles; % total number of vehicles

% Bounded totals (linear expressions made explicit as variables)
var 0..(capacity[1]*max4 + capacity[2]*max3): total_luggage;
var 0..max_pollut: total_pollution;


% Constraints
% Linking constraint: total vehicles is the sum of each vehicle type purchased
constraint
  total_vehicles = num_4w + num_3w;

% Define total luggage moved as a linear combination of vehicle counts
constraint
  total_luggage = capacity[1] * num_4w + capacity[2] * num_3w;

% Define total pollution produced as a linear combination of vehicle counts
constraint
  total_pollution = pollut[1] * num_4w + pollut[2] * num_3w;

% Demand satisfaction: move at least the required amount of luggage per day
constraint
  total_luggage >= min_luggage;

% Environmental limit: do not exceed maximum allowed pollutant per day
constraint
  total_pollution <= max_pollut;


% Objective
solve minimize total_vehicles;