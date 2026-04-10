% Parameters
int: metal_J = 5;          % Metal units extracted per process J
int: water_J = 8;          % Water units used per process J
int: pollution_J = 3;      % Pollution units produced per process J

int: metal_P = 9;          % Metal units extracted per process P
int: water_P = 6;          % Water units used per process P
int: pollution_P = 5;      % Pollution units produced per process P

int: water_max = 1500;     % Maximum available water
int: pollution_max = 1350; % Maximum allowed pollution


% Variables
var 0..(water_max div water_J): num_J;  % Number of times to run process J (bounded by water)
var 0..(water_max div water_P): num_P;  % Number of times to run process P (bounded by water)

var 0..(metal_J * (water_max div water_J) + metal_P * (water_max div water_P)): total_metal;
% Total metal extracted (upper bound derived from max runs under water bounds)


% Constraints
% Link total_metal to the chosen numbers of processes
constraint
  total_metal = metal_J * num_J + metal_P * num_P;

% Resource constraint: total water used cannot exceed available water
constraint
  water_J * num_J + water_P * num_P <= water_max;

% Environmental constraint: total pollution produced cannot exceed allowed pollution
constraint
  pollution_J * num_J + pollution_P * num_P <= pollution_max;


% Objective
solve maximize total_metal;