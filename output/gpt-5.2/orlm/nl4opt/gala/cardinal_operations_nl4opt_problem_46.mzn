% Tea estate machine allocation (all data embedded)

% Parameters
int: land = 500;                 % acres available
int: fuel_available = 9000;      % liters
int: waste_cap = 6000;           % kg

int: tea_trad = 30;              % kg per acre
int: waste_trad = 10;            % kg per acre
int: fuel_trad = 20;             % liters per acre

int: tea_mod = 40;               % kg per acre
int: waste_mod = 15;             % kg per acre
int: fuel_mod = 15;              % liters per acre

% Decision variables: acres assigned to each machine
var 0..land: acres_trad;
var 0..land: acres_mod;

% Resource constraints
constraint acres_trad + acres_mod <= land;
constraint fuel_trad * acres_trad + fuel_mod * acres_mod <= fuel_available;
constraint waste_trad * acres_trad + waste_mod * acres_mod <= waste_cap;

% Objective: maximize tea leaves picked
var 0..(tea_trad*land + tea_mod*land): total_tea =
  tea_trad * acres_trad + tea_mod * acres_mod;

solve maximize total_tea;

output [
  "Acres traditional = ", show(acres_trad), "\n",
  "Acres modern      = ", show(acres_mod), "\n",
  "Total tea (kg)    = ", show(total_tea), "\n",
  "Fuel used (L)     = ", show(fuel_trad*acres_trad + fuel_mod*acres_mod), "\n",
  "Waste (kg)        = ", show(waste_trad*acres_trad + waste_mod*acres_mod), "\n",
  "Land used (acres) = ", show(acres_trad + acres_mod), "\n"
];