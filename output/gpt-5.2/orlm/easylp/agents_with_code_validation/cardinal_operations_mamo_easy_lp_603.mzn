% Parameters
% Cost per unit allocation in each category
int: cost_stock = 5;
int: cost_rent = 4;
int: cost_wages = 3;
int: cost_utilities = 2;

% Minimum budget requirements (units)
int: min_stock = 1000;
int: min_rent = 500;
int: min_wages = 1200;
int: min_utilities = 300;

% Constraint thresholds (units)
int: min_diff_stock_rent = 1000;     % stock - rent >= 1000
int: max_wages_utilities = 5000;     % wages + utilities <= 5000
int: min_diff_stock_wages = 1500;    % stock - wages >= 1500
int: rent_utilities_sum = 2000;      % rent + utilities == 2000

% Variables
% Monthly budget allocations (whole units)
var int: stock;      % allocation to Stock
var int: rent;       % allocation to Rent
var int: wages;      % allocation to Wages
var int: utilities;  % allocation to Utilities

% Total monthly expenditure (unit currency)
var int: total_cost;

% Constraints
% --- Minimum budget requirements for each category ---
constraint stock >= min_stock;
constraint rent >= min_rent;
constraint wages >= min_wages;
constraint utilities >= min_utilities;

% --- Difference constraints between key allocations ---
constraint stock - rent >= min_diff_stock_rent;      % Stock exceeds Rent by at least threshold
constraint stock - wages >= min_diff_stock_wages;    % Stock exceeds Wages by at least threshold

% --- Combined allocation limit for Wages and Utilities ---
constraint wages + utilities <= max_wages_utilities;

% --- Exact sum requirement for Rent and Utilities ---
constraint rent + utilities == rent_utilities_sum;

% --- Total expenditure definition (linking costs to allocations) ---
constraint
  total_cost = cost_stock * stock
             + cost_rent * rent
             + cost_wages * wages
             + cost_utilities * utilities;

% Objective
solve minimize total_cost;

% Optional output (kept minimal and clear)
output [
  "stock=", show(stock), "\n",
  "rent=", show(rent), "\n",
  "wages=", show(wages), "\n",
  "utilities=", show(utilities), "\n",
  "total_cost=", show(total_cost), "\n"
];