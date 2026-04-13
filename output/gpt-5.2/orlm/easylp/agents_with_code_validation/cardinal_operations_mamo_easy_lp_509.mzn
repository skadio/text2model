% Parameters
int: budget = 1000;                 % Maximum total investment allowed
int: rhs_c1 = 200;                  % RHS for constraint: 2*x1 - 3*x2 >= 200
int: rhs_c2 = 300;                  % RHS for constraint: x1 - 0.5*x3 <= 300
int: rhs_c3 = -500;                 % RHS for constraint: 2.5*x2 - x1 - x3 >= -500

int: cost1 = 50;                    % Unit cost coefficient for x1
int: cost2 = 60;                    % Unit cost coefficient for x2
int: cost3 = 70;                    % Unit cost coefficient for x3

% Variables
var 0..budget: x1;                  % Integer units invested in project 1
var 0..budget: x2;                  % Integer units invested in project 2
var 0..budget: x3;                  % Integer units invested in project 3

% Total cost (bounded above by investing full budget in all three variables' domains)
var 0..(cost1*budget + cost2*budget + cost3*budget): total_cost;

% Constraints
% Budget constraint: total allocation cannot exceed available budget
constraint x1 + x2 + x3 <= budget;

% Linear inequality c1: 2*x1 - 3*x2 >= 200
constraint 2 * x1 - 3 * x2 >= rhs_c1;

% Linear inequality c2: x1 - 0.5*x3 <= 300
% Multiply by 2 to avoid fractional coefficient: 2*x1 - x3 <= 600
constraint 2 * x1 - x3 <= 2 * rhs_c2;

% Linear inequality c3: 2.5*x2 - x1 - x3 >= -500
% Multiply by 2 to avoid fractional coefficient: 5*x2 - 2*x1 - 2*x3 >= -1000
constraint 5 * x2 - 2 * x1 - 2 * x3 >= 2 * rhs_c3;

% Define total_cost from unit costs and allocations
constraint total_cost = cost1 * x1 + cost2 * x2 + cost3 * x3;

% Objective
solve minimize total_cost;