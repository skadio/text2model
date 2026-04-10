% Parameters
% Profit (£/kg)
int: profit_A = 30;
int: profit_B = 10;

% Production time (hours/kg)
int: hours_per_kg_A = 6;
int: hours_per_kg_B = 3;

% Weekly limits
int: max_hours_per_week = 40;

% Demand relationship: B >= demand_ratio_B_to_A * A
int: demand_ratio_B_to_A = 3;

% Storage: A uses storage_A_to_B times storage of B; and A has an absolute cap
int: storage_A_to_B = 4;     % given but not needed directly due to explicit cap on A
int: max_store_A = 4;        % kg/week

% Derived bounds for variable declarations
% From time limit: 6*A <= 40 => A <= floor(40/6) = 6; and also A <= 4 by storage cap
int: max_A = min(max_store_A, max_hours_per_week div hours_per_kg_A);
% From time limit: 3*B <= 40 => B <= floor(40/3) = 13
int: max_B = max_hours_per_week div hours_per_kg_B;

% Variables
var 0..max_A: kg_A;   % kilograms of product A produced/sold per week
var 0..max_B: kg_B;   % kilograms of product B produced/sold per week
var int: profit;      % total weekly profit (£)

% Constraints

% --- Production time capacity (hours/week) ---
constraint
  hours_per_kg_A * kg_A + hours_per_kg_B * kg_B <= max_hours_per_week;

% --- Market demand relationship: B output at least a multiple of A ---
constraint
  kg_B >= demand_ratio_B_to_A * kg_A;

% --- Storage limitation: absolute cap on product A (kg/week) ---
constraint
  kg_A <= max_store_A;

% --- Profit definition (linear expression) ---
constraint
  profit = profit_A * kg_A + profit_B * kg_B;

% Objective
solve maximize profit;