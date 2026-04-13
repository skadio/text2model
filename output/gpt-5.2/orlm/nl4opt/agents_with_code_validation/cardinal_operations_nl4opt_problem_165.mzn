% Parameters
% Profit per taco (in cents to keep integer arithmetic)
int: profit_regular = 250;  % $2.50
int: profit_deluxe  = 355;  % $3.55

% Demand upper bounds
int: max_regular = 50;
int: max_deluxe  = 40;

% Total supply limit (both types combined)
int: max_total = 70;

% Variables
var 0..max_regular: x1;  % number of regular tacos to make
var 0..max_deluxe:  x2;  % number of deluxe tacos to make

% Constraints
% Demand limits are enforced by variable domains:
%   x1 in 0..max_regular, x2 in 0..max_deluxe

% Total supply limit (both taco types combined)
constraint x1 + x2 <= max_total;

% Objective
% Maximize total profit (in cents)
solve maximize profit_regular * x1 + profit_deluxe * x2;