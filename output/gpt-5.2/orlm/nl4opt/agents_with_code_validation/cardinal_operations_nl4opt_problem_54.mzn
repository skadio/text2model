% Parameters
% Minimum required nutrients per day
int: min_calcium = 100;
int: min_iron = 50;

% Cost and nutrient content per serving
int: cost_milk = 1;          % dollars per glass of milk
int: calcium_milk = 40;      % calcium units per glass
int: iron_milk = 25;         % iron units per glass

int: cost_veg = 2;           % dollars per plate of vegetables
int: calcium_veg = 15;       % calcium units per plate
int: iron_veg = 30;          % iron units per plate


% Variables
% Number of servings consumed (nonnegative integers)
var 0..100: milk_glasses;    % glasses of milk per day
var 0..100: veg_plates;      % plates of vegetables per day

% Total daily cost
var 0..1000: total_cost;     % dollars per day


% Constraints
% Link total_cost to the chosen quantities and their unit costs
constraint
  total_cost = cost_milk * milk_glasses + cost_veg * veg_plates;

% Meet minimum daily calcium requirement
constraint
  calcium_milk * milk_glasses + calcium_veg * veg_plates >= min_calcium;

% Meet minimum daily iron requirement
constraint
  iron_milk * milk_glasses + iron_veg * veg_plates >= min_iron;


% Objective
solve minimize total_cost;

output [
  "milk_glasses = ", show(milk_glasses), "\n",
  "veg_plates = ", show(veg_plates), "\n",
  "total_cost = ", show(total_cost), "\n"
];