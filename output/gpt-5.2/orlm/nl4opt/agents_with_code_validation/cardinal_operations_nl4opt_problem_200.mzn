% Parameters
int: total_space = 100;                 % Total available factory space (sq. feet)

int: labor_per_sqft_phone = 2;          % Labor hours required per sq. foot of phone production
int: labor_per_sqft_laptop = 3;         % Labor hours required per sq. foot of laptop production
int: labor_budget = 2000;               % Maximum labor hours available

int: cost_per_sqft_phone = 12;          % Cost per sq. foot allocated to phones
int: cost_per_sqft_laptop = 15;         % Cost per sq. foot allocated to laptops
int: cost_budget = 5000;                % Maximum spending allowed

int: revenue_per_sqft_phone = 50;       % Net revenue per sq. foot from phones
int: revenue_per_sqft_laptop = 70;      % Net revenue per sq. foot from laptops

% Variables
var 0..total_space: space_phone;        % Sq. feet allocated to phone production
var 0..total_space: space_laptop;       % Sq. feet allocated to laptop production

var 0..(revenue_per_sqft_phone * total_space
      + revenue_per_sqft_laptop * total_space): total_revenue;  % Total net revenue

% Constraints
% Space allocation must not exceed total available factory space
constraint
  space_phone + space_laptop <= total_space;

% Labor budget constraint (total labor used by chosen layout must be within available hours)
constraint
  labor_per_sqft_phone * space_phone
+ labor_per_sqft_laptop * space_laptop
<= labor_budget;

% Spending (cost) budget constraint (total cost of allocated space must be within budget)
constraint
  cost_per_sqft_phone * space_phone
+ cost_per_sqft_laptop * space_laptop
<= cost_budget;

% Define total revenue based on allocated space
constraint
  total_revenue =
    revenue_per_sqft_phone * space_phone
  + revenue_per_sqft_laptop * space_laptop;

% Objective
solve maximize total_revenue;

output [
  "space_phone = ", show(space_phone), "\n",
  "space_laptop = ", show(space_laptop), "\n",
  "total_revenue = ", show(total_revenue), "\n"
];