% Parameters
% Demand lower bounds (units/day)
int: min_desk_demand = 30;
int: min_night_demand = 50;

% Production capacity upper bounds (units/day)
int: max_desk_capacity = 150;
int: max_night_capacity = 180;

% Contract requirement (total lamps/day)
int: min_total_lamps = 100;

% Profit per unit ($/lamp)
int: profit_desk = 5;
int: profit_night = 8;

% Variables
% Number of desk-lamps produced per day
var min_desk_demand..max_desk_capacity: desk_lamps;

% Number of night-lamps produced per day
var min_night_demand..max_night_capacity: night_lamps;

% Total profit per day ($)
var 0..(max_desk_capacity * profit_desk + max_night_capacity * profit_night): total_profit;

% Constraints
% Meet minimum total production required by the contract
constraint desk_lamps + night_lamps >= min_total_lamps;

% Define total profit as profit from desk-lamps and night-lamps
constraint total_profit = profit_desk * desk_lamps + profit_night * night_lamps;

% Objective
solve maximize total_profit;