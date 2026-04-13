% Parameters
% Capacity limits
int: cap12 = 5000;    % Maximum total allocation for production lines x1 and x2
int: cap34 = 2000;    % Maximum total allocation for production lines x3 and x4

% Minimum requirement
int: min_req = 100;   % Minimum value for (x2 + 3*x4 - x1)

% Unit costs
int: cost1 = 50;      % Cost per unit for x1
int: cost2 = 60;      % Cost per unit for x2
int: cost3 = 30;      % Cost per unit for x3
int: cost4 = 20;      % Cost per unit for x4


% Variables
var 0..cap12: x1;  % Allocation to production line 1 (non-negative integer)
var 0..cap12: x2;  % Allocation to production line 2 (non-negative integer)
var 0..cap34: x3;  % Allocation to production line 3 (non-negative integer)
var 0..cap34: x4;  % Allocation to production line 4 (non-negative integer)

% Total cost (upper bound is a safe linear bound)
var 0..(cost1*cap12 + cost2*cap12 + cost3*cap34 + cost4*cap34): total_cost;


% Constraints
% Capacity constraints for grouped production lines
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

% Production relationship constraints
constraint 2 * x1 + 4 * x2 >= x3;
constraint x2 + 3 * x4 - x1 >= min_req;

% Total cost definition
constraint total_cost = cost1 * x1 + cost2 * x2 + cost3 * x3 + cost4 * x4;


% Objective
solve minimize total_cost;