% Parameters
int: max_total_packages = 100;          % Capacity limit on total packages sold
int: max_x_packages = 70;               % Upper bound on X packages
int: max_y_packages = 50;               % Upper bound on Y packages
int: min_x_offset = 10;                 % X must be at least this much more than 2*Y
int: max_diff_y_minus_halfx = 20;       % Upper bound on (Y - floor(X/2))
int: cost_x = 50;                       % Cost per X package
int: cost_y = 80;                       % Cost per Y package

% Variables
var 0..max_x_packages: x_sold;          % Number of X packages sold (integer)
var 0..max_y_packages: y_sold;          % Number of Y packages sold (integer)
var 0..(cost_x*max_x_packages + cost_y*max_y_packages): total_cost; % Total cost

% Constraints
% --- Capacity constraint: total sold cannot exceed overall capacity ---
constraint x_sold + y_sold <= max_total_packages;

% --- Portfolio diversity constraint: X must dominate relative to Y ---
constraint x_sold >= 2 * y_sold + min_x_offset;

% --- Representation balance constraint: (Y - floor(X/2)) bounded above ---
% Using integer division to model "rounded down" half of X.
constraint y_sold - (x_sold div 2) <= max_diff_y_minus_halfx;

% --- Total cost definition ---
constraint total_cost = cost_x * x_sold + cost_y * y_sold;

% Objective
solve minimize total_cost;