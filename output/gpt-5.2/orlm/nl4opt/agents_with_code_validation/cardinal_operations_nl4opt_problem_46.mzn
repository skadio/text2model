% Parameters
int: total_land = 500;                 % Total available land (acres)

int: fuel_available = 9000;            % Total available fuel (liters)
int: waste_capacity = 6000;            % Maximum allowable waste (kg)

int: tea_trad_per_acre = 30;           % Tea picked per acre using traditional machine (kg)
int: waste_trad_per_acre = 10;         % Waste produced per acre using traditional machine (kg)
int: fuel_trad_per_acre = 20;          % Fuel used per acre using traditional machine (liters)

int: tea_mod_per_acre = 40;            % Tea picked per acre using modern machine (kg)
int: waste_mod_per_acre = 15;          % Waste produced per acre using modern machine (kg)
int: fuel_mod_per_acre = 15;           % Fuel used per acre using modern machine (liters)

% Variables
var 0..total_land: acres_traditional;  % Acres assigned to traditional machine
var 0..total_land: acres_modern;       % Acres assigned to modern machine

% Totals (bounded conservatively by using all land with the max per-acre coefficients)
var 0..(tea_trad_per_acre*total_land + tea_mod_per_acre*total_land): total_tea;       % Total tea picked (kg)
var 0..(waste_trad_per_acre*total_land + waste_mod_per_acre*total_land): total_waste; % Total waste (kg)
var 0..(fuel_trad_per_acre*total_land + fuel_mod_per_acre*total_land): total_fuel;    % Total fuel used (liters)

% Constraints
% Land allocation constraint: total acres used by both machines cannot exceed available land
constraint
  acres_traditional + acres_modern <= total_land;

% Define total tea picked as a linear function of acres assigned to each machine
constraint
  total_tea =
    tea_trad_per_acre * acres_traditional +
    tea_mod_per_acre * acres_modern;

% Define total waste produced as a linear function of acres assigned to each machine
constraint
  total_waste =
    waste_trad_per_acre * acres_traditional +
    waste_mod_per_acre * acres_modern;

% Define total fuel used as a linear function of acres assigned to each machine
constraint
  total_fuel =
    fuel_trad_per_acre * acres_traditional +
    fuel_mod_per_acre * acres_modern;

% Resource capacity constraint: fuel usage cannot exceed available fuel
constraint
  total_fuel <= fuel_available;

% Resource capacity constraint: waste produced cannot exceed waste handling capacity
constraint
  total_waste <= waste_capacity;

% Objective
solve maximize total_tea;