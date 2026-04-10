% Parameters
int: total_acres = 50;                 % Total available land (acres)
int: min_potato_acres = 12;            % Minimum acres of potatoes (contract)
int: min_cucumber_acres = 15;          % Minimum acres of cucumbers (contract)
int: profit_per_acre_potatoes = 500;   % Profit per acre of potatoes ($)
int: profit_per_acre_cucumbers = 650;  % Profit per acre of cucumbers ($)

% Variables
var 0..total_acres: potato_acres;      % Acres allocated to potatoes
var 0..total_acres: cucumber_acres;    % Acres allocated to cucumbers
var 0..(profit_per_acre_potatoes*total_acres
      + profit_per_acre_cucumbers*total_acres): total_profit; % Total profit ($)

% Constraints

% Land availability: total planted acres cannot exceed available land
constraint
  potato_acres + cucumber_acres <= total_acres;

% Contract minimums: must plant at least the required acres of each crop
constraint
  potato_acres >= min_potato_acres;
constraint
  cucumber_acres >= min_cucumber_acres;

% Preference/resource relationship:
% Prefer more cucumbers than potatoes, but cucumbers cannot exceed twice potatoes
constraint
  cucumber_acres >= potato_acres + 1;     % strictly more cucumbers than potatoes
constraint
  cucumber_acres <= 2 * potato_acres;     % at most twice as many cucumbers as potatoes

% Profit definition: compute total profit from planted acres
constraint
  total_profit = profit_per_acre_potatoes * potato_acres
               + profit_per_acre_cucumbers * cucumber_acres;

% Objective
solve maximize total_profit;