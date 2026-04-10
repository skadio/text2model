% Parameters
int: total_acres = 300;                 % Total available land (acres)
int: total_watering_budget = 10000;     % Total watering budget ($)
int: total_labor_days = 575;            % Total available labor (days)

int: labor_per_acre_blueberries = 6;    % Labor required per acre of blueberries (days)
int: labor_per_acre_raspberries = 3;    % Labor required per acre of raspberries (days)

int: water_cost_per_acre_blueberries = 22; % Watering cost per acre of blueberries ($)
int: water_cost_per_acre_raspberries = 25; % Watering cost per acre of raspberries ($)

int: profit_per_acre_blueberries = 56;  % Profit per acre of blueberries ($)
int: profit_per_acre_raspberries = 75;  % Profit per acre of raspberries ($)

% Variables
var 0..total_acres: acres_blueberries;  % Acres planted with blueberries
var 0..total_acres: acres_raspberries;  % Acres planted with raspberries

% Total profit ($), bounded by the theoretical max if all acres were either crop
var 0..(profit_per_acre_blueberries*total_acres + profit_per_acre_raspberries*total_acres): total_profit;

% Constraints
% Land availability: total planted acres cannot exceed available land
constraint acres_blueberries + acres_raspberries <= total_acres;

% Labor availability: labor used by both crops cannot exceed available labor days
constraint
  labor_per_acre_blueberries * acres_blueberries
+ labor_per_acre_raspberries * acres_raspberries
<= total_labor_days;

% Watering budget: watering costs for both crops cannot exceed total budget
constraint
  water_cost_per_acre_blueberries * acres_blueberries
+ water_cost_per_acre_raspberries * acres_raspberries
<= total_watering_budget;

% Total profit definition: link total_profit to decision variables
constraint
  total_profit =
    profit_per_acre_blueberries * acres_blueberries
  + profit_per_acre_raspberries * acres_raspberries;

% Objective
solve maximize total_profit;