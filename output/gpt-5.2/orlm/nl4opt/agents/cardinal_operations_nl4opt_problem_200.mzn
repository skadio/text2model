% Parameters
int: total_space = 100;                 % Total available space (sq. feet)
int: max_budget = 5000;                 % Maximum spending allowed ($)
int: max_labor_hours = 2000;            % Maximum labor hours available

int: phone_labor_per_sqft = 2;          % Labor hours required per sq. foot for phones
int: laptop_labor_per_sqft = 3;         % Labor hours required per sq. foot for laptops

int: phone_cost_per_sqft = 12;          % Cost per sq. foot allocated to phones ($)
int: laptop_cost_per_sqft = 15;         % Cost per sq. foot allocated to laptops ($)

int: phone_revenue_per_sqft = 50;       % Net revenue per sq. foot for phones ($)
int: laptop_revenue_per_sqft = 70;      % Net revenue per sq. foot for laptops ($)

% Variables
var 0..total_space: phone_space;        % Sq. feet allocated to phone production
var 0..total_space: laptop_space;       % Sq. feet allocated to laptop production

var 0..max_budget: total_cost;          % Total cost ($)
var 0..max_labor_hours: total_labor;    % Total labor hours used
var 0..(phone_revenue_per_sqft*total_space + laptop_revenue_per_sqft*total_space): total_revenue; % Total revenue ($)

% Constraints
% Space allocation constraint: total allocated space cannot exceed available factory space
constraint
  phone_space + laptop_space <= total_space;

% Cost calculation and budget limit: define total_cost and ensure it stays within max_budget
constraint
  total_cost = phone_cost_per_sqft * phone_space
             + laptop_cost_per_sqft * laptop_space;

constraint
  total_cost <= max_budget;

% Labor calculation and labor-hour limit: define total_labor and ensure it stays within max_labor_hours
constraint
  total_labor = phone_labor_per_sqft * phone_space
              + laptop_labor_per_sqft * laptop_space;

constraint
  total_labor <= max_labor_hours;

% Revenue calculation: define total_revenue based on allocated space and per-sqft revenues
constraint
  total_revenue = phone_revenue_per_sqft * phone_space
                + laptop_revenue_per_sqft * laptop_space;

% Objective
solve maximize total_revenue;