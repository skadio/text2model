% Parameters
% Demand and capacity limits (embedded directly as per instructions)
int: min_desk_demand = 30;
int: min_night_demand = 50;
int: max_desk_capacity = 150;
int: max_night_capacity = 180;
int: min_total_lamps = 100;

% Profit per unit
int: profit_desk = 5;
int: profit_night = 8;

% Variables
% Number of desk-lamps produced (bounded by demand and capacity)
var min_desk_demand..max_desk_capacity: desk_lamps;

% Number of night-lamps produced (bounded by demand and capacity)
var min_night_demand..max_night_capacity: night_lamps;

% Total profit (explicitly bounded for safe linear usage)
var 0..(max_desk_capacity * profit_desk + max_night_capacity * profit_night): total_profit;

% Constraints
% Minimum total production to satisfy the contract
constraint desk_lamps + night_lamps >= min_total_lamps;

% Link total_profit to production quantities and unit profits
constraint total_profit = desk_lamps * profit_desk + night_lamps * profit_night;

% Objective
solve maximize total_profit;