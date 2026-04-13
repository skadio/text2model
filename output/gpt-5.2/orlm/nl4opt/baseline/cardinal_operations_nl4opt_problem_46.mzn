% Tea estate machine allocation (all data embedded)

% Data
int: land_available = 500;          % acres
int: fuel_available = 9000;         % liters
int: waste_capacity = 6000;         % kg

int: tea_traditional = 30;          % kg per acre
int: waste_traditional = 10;        % kg per acre
int: fuel_traditional = 20;         % liters per acre

int: tea_modern = 40;               % kg per acre
int: waste_modern = 15;             % kg per acre
int: fuel_modern = 15;              % liters per acre

% Decision variables: acres assigned to each machine (integer acres)
var 0..land_available: acres_traditional;
var 0..land_available: acres_modern;

% Constraints
constraint acres_traditional + acres_modern <= land_available;
constraint fuel_traditional * acres_traditional + fuel_modern * acres_modern <= fuel_available;
constraint waste_traditional * acres_traditional + waste_modern * acres_modern <= waste_capacity;

% Objective: maximize tea leaves picked
var int: total_tea = tea_traditional * acres_traditional + tea_modern * acres_modern;
solve maximize total_tea;

output [
  "Acres (traditional) = ", show(acres_traditional), "\n",
  "Acres (modern)      = ", show(acres_modern), "\n",
  "Total tea (kg)      = ", show(total_tea), "\n",
  "Fuel used (L)       = ", show(fuel_traditional * acres_traditional + fuel_modern * acres_modern), "\n",
  "Waste produced (kg) = ", show(waste_traditional * acres_traditional + waste_modern * acres_modern), "\n"
];