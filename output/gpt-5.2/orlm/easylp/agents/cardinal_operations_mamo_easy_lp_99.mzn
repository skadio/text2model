% Parameters
int: max_hires = 50;                 % Maximum total hires allowed (X + Y)
int: cost_x = 5000;                  % Training/onboarding cost per hire in position X
int: cost_y = 8000;                  % Training/onboarding cost per hire in position Y
int: ratio = 3;                      % X must be at least 3 times the number of "not hired for Y" out of max_hires

% Variables
var 0..max_hires: x;                 % Number of hires for position X
var 0..max_hires: y;                 % Number of hires for position Y
var 0..(cost_x*max_hires + cost_y*max_hires): total_cost;  % Total cost in dollars

% Constraints
% Total hires must not exceed the maximum allowed
constraint
  x + y <= max_hires;

% Definition of total cost based on hires in each position
constraint
  total_cost = cost_x * x + cost_y * y;

% Staffing ratio requirement:
% x must be at least "ratio" times the number of slots not used for position Y (max_hires - y)
constraint
  x >= ratio * (max_hires - y);

% Objective
solve minimize total_cost;