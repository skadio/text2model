% Parameters
int: total_acres = 300;                  % Total available land (acres)
int: watering_budget = 10000;            % Total watering budget ($)
int: labor_days_available = 575;         % Total labor available (days)

int: labor_per_acre_blueberries = 6;     % Labor needed per acre of blueberries (days)
int: watering_per_acre_blueberries = 22; % Watering cost per acre of blueberries ($)
int: profit_per_acre_blueberries = 56;   % Profit per acre of blueberries ($)

int: labor_per_acre_raspberries = 3;     % Labor needed per acre of raspberries (days)
int: watering_per_acre_raspberries = 25; % Watering cost per acre of raspberries ($)
int: profit_per_acre_raspberries = 75;   % Profit per acre of raspberries ($)

% Variables
var 0..total_acres: acres_blueberries;   % Acres planted with blueberries
var 0..total_acres: acres_raspberries;   % Acres planted with raspberries

var 0..(profit_per_acre_blueberries*total_acres + profit_per_acre_raspberries*total_acres): total_profit;
                                         % Total profit ($), upper bound if all acres used

% Constraints
% Land availability: total planted acres cannot exceed total land
constraint
  acres_blueberries + acres_raspberries <= total_acres;

% Labor availability: labor used by planted acres cannot exceed available labor days
constraint
  labor_per_acre_blueberries * acres_blueberries
+ labor_per_acre_raspberries * acres_raspberries
  <= labor_days_available;

% Watering budget: watering costs for planted acres cannot exceed budget
constraint
  watering_per_acre_blueberries * acres_blueberries
+ watering_per_acre_raspberries * acres_raspberries
  <= watering_budget;

% Profit accounting: link total_profit to the planted acres and per-acre profits
constraint
  total_profit =
    profit_per_acre_blueberries * acres_blueberries
  + profit_per_acre_raspberries * acres_raspberries;

% Objective
solve maximize total_profit;