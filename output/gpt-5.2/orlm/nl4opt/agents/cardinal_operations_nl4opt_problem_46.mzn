% Parameters
int: total_land = 500;                 % Total available acres of land
int: fuel_available = 9000;            % Total available fuel (liters)
int: waste_capacity = 6000;            % Maximum waste that can be handled (kg)

int: tea_traditional_per_acre = 30;    % Tea leaves picked per acre by traditional machine (kg)
int: waste_traditional_per_acre = 10;  % Waste created per acre by traditional machine (kg)
int: fuel_traditional_per_acre = 20;   % Fuel required per acre by traditional machine (liters)

int: tea_modern_per_acre = 40;         % Tea leaves picked per acre by modern machine (kg)
int: waste_modern_per_acre = 15;       % Waste created per acre by modern machine (kg)
int: fuel_modern_per_acre = 15;        % Fuel required per acre by modern machine (liters)

% Variables
var 0..total_land: acres_traditional;  % Acres assigned to traditional machine
var 0..total_land: acres_modern;       % Acres assigned to modern machine

% Totals (upper bounds are safe maxima assuming all land is used by one type)
var 0..(tea_traditional_per_acre * total_land + tea_modern_per_acre * total_land): total_tea_picked; % Total tea picked (kg)
var 0..(waste_traditional_per_acre * total_land + waste_modern_per_acre * total_land): total_waste;  % Total waste produced (kg)
var 0..(fuel_traditional_per_acre * total_land + fuel_modern_per_acre * total_land): total_fuel;     % Total fuel used (liters)

% Constraints
% Land allocation constraint: total acres used cannot exceed available land
constraint acres_traditional + acres_modern <= total_land;

% Link total tea picked to acres assigned to each machine
constraint total_tea_picked =
  tea_traditional_per_acre * acres_traditional +
  tea_modern_per_acre * acres_modern;

% Link total waste produced to acres assigned to each machine
constraint total_waste =
  waste_traditional_per_acre * acres_traditional +
  waste_modern_per_acre * acres_modern;

% Link total fuel used to acres assigned to each machine
constraint total_fuel =
  fuel_traditional_per_acre * acres_traditional +
  fuel_modern_per_acre * acres_modern;

% Resource capacity constraint: fuel usage must not exceed available fuel
constraint total_fuel <= fuel_available;

% Resource capacity constraint: waste produced must not exceed waste handling capacity
constraint total_waste <= waste_capacity;

% Objective
solve maximize total_tea_picked;