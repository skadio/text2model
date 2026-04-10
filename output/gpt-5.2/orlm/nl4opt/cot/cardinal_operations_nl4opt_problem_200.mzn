% Parameters (with values embedded)
int: total_space = 100;                 % sq. feet available
int: max_budget = 5000;                 % dollars
int: max_labor = 2000;                  % hours

int: labor_per_sqft_phone = 2;          % hours per sq. foot
int: labor_per_sqft_laptop = 3;         % hours per sq. foot

int: cost_per_sqft_phone = 12;          % dollars per sq. foot
int: cost_per_sqft_laptop = 15;         % dollars per sq. foot

int: revenue_per_sqft_phone = 50;       % dollars per sq. foot
int: revenue_per_sqft_laptop = 70;      % dollars per sq. foot

% Variables
var 0..total_space: x_phone;            % sq. feet allocated to phones
var 0..total_space: x_laptop;           % sq. feet allocated to laptops
var 0..(revenue_per_sqft_phone*total_space + revenue_per_sqft_laptop*total_space): total_revenue;

% Constraints
constraint x_phone + x_laptop <= total_space;

constraint cost_per_sqft_phone * x_phone + cost_per_sqft_laptop * x_laptop <= max_budget;

constraint labor_per_sqft_phone * x_phone + labor_per_sqft_laptop * x_laptop <= max_labor;

constraint total_revenue = revenue_per_sqft_phone * x_phone + revenue_per_sqft_laptop * x_laptop;

% Objective
solve maximize total_revenue;