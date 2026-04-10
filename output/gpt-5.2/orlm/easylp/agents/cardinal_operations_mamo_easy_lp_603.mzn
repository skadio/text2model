% Parameters
% Cost per unit allocation in each category
int: cost_stock = 5;
int: cost_rent = 4;
int: cost_wages = 3;
int: cost_utilities = 2;

% Minimum allocation requirements (whole units)
int: min_stock = 1000;
int: min_rent = 500;
int: min_wages = 1200;
int: min_utilities = 300;

% Constraint thresholds
int: min_diff_stock_rent = 1000;      % Stock - Rent >= 1000
int: max_wages_plus_utilities = 5000; % Wages + Utilities <= 5000
int: min_diff_stock_wages = 1500;     % Stock - Wages >= 1500
int: rent_plus_utilities_eq = 2000;   % Rent + Utilities = 2000

% Variables
% Monthly budget allocations (whole units)
var int: stock;      % allocation for Stock
var int: rent;       % allocation for Rent
var int: wages;      % allocation for Wages
var int: utilities;  % allocation for Utilities

% Total monthly expenditure (unit currency)
var int: total_cost;

% Constraints
% Minimum allocation requirements for each category
constraint stock >= min_stock;
constraint rent >= min_rent;
constraint wages >= min_wages;
constraint utilities >= min_utilities;

% Operational difference requirements (interpreted as directional differences)
constraint stock - rent >= min_diff_stock_rent;
constraint stock - wages >= min_diff_stock_wages;

% Limit on combined Wages and Utilities allocation
constraint wages + utilities <= max_wages_plus_utilities;

% Exact sum requirement for Rent and Utilities
constraint rent + utilities = rent_plus_utilities_eq;

% Total monthly expenditure calculation
constraint total_cost =
    cost_stock * stock +
    cost_rent * rent +
    cost_wages * wages +
    cost_utilities * utilities;

% Objective
solve minimize total_cost;