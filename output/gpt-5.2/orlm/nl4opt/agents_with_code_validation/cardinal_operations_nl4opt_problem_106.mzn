% Parameters
int: total_acres = 50;                 % Total available land (acres)

int: min_potatoes = 12;                % Minimum acres of potatoes required
int: min_cucumbers = 15;               % Minimum acres of cucumbers required

int: profit_per_acre_potatoes = 500;   % Profit per acre of potatoes ($)
int: profit_per_acre_cucumbers = 650;  % Profit per acre of cucumbers ($)

% Variables
var 0..total_acres: acres_potatoes;    % Acres allocated to potatoes
var 0..total_acres: acres_cucumbers;   % Acres allocated to cucumbers

var 0..(profit_per_acre_potatoes*total_acres + profit_per_acre_cucumbers*total_acres): total_profit;
                                       % Total profit ($)

% Constraints

% Land availability: total planted acres cannot exceed available land
constraint
  acres_potatoes + acres_cucumbers <= total_acres;

% Contract minimums: must grow at least the required acres of each crop
constraint
  acres_potatoes >= min_potatoes;

constraint
  acres_cucumbers >= min_cucumbers;

% Preference/resource relationship:
% prefers more cucumbers than potatoes (strictly more)
constraint
  acres_cucumbers > acres_potatoes;

% resource limit: at most twice as many cucumbers as potatoes
constraint
  acres_cucumbers <= 2 * acres_potatoes;

% Define total profit from acreage decisions
constraint
  total_profit =
    profit_per_acre_potatoes * acres_potatoes +
    profit_per_acre_cucumbers * acres_cucumbers;

% Objective
solve maximize total_profit;