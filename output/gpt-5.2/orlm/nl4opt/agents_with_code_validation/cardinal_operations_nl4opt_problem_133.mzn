% Parameters
int: metal_per_J = 5;          % Metal extracted per unit of process J
int: water_per_J = 8;          % Water used per unit of process J
int: pollution_per_J = 3;      % Pollution produced per unit of process J

int: metal_per_P = 9;          % Metal extracted per unit of process P
int: water_per_P = 6;          % Water used per unit of process P
int: pollution_per_P = 5;      % Pollution produced per unit of process P

int: max_water = 1500;         % Maximum available water
int: max_pollution = 1350;     % Maximum allowed pollution

% Variables
var 0..(max_water div water_per_J): num_J;  % Number of times process J is performed
var 0..(max_water div water_per_P): num_P;  % Number of times process P is performed

% Upper bound based on maximum possible metal under water-only limits
var 0..(metal_per_J * (max_water div water_per_J) + metal_per_P * (max_water div water_per_P)): total_metal;

% Constraints
% Water usage limit
constraint water_per_J * num_J + water_per_P * num_P <= max_water;

% Pollution limit
constraint pollution_per_J * num_J + pollution_per_P * num_P <= max_pollution;

% Total metal definition
constraint total_metal = metal_per_J * num_J + metal_per_P * num_P;

% Objective
solve maximize total_metal;