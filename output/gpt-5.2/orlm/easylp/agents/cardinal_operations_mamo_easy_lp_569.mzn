% Parameters
% Unit costs for each project (given)
int: cost_x1 = 4;
int: cost_x2 = 5;
int: cost_x3 = 6;

% Constraint coefficients / RHS values (given)
int: rhs_1 = 1000;  % x1 + 2*x2 <= 1000
int: rhs_2 = 600;   % x2 + 3*x3 >= 600
int: rhs_3 = 500;   % 2*x3 - x1 == 500

% Useful variable bounds derived from constraints (to keep variables bounded)
% From 2*x3 - x1 = 500 and x1 >= 0 => x3 >= 250
int: x3_lb = 250;

% From x1 + 2*x2 <= 1000 and x1,x2 >= 0 => x1 <= 1000, x2 <= 500
int: x1_ub = 1000;
int: x2_ub = 500;

% From x1 = 2*x3 - 500 and x1 <= 1000 => 2*x3 - 500 <= 1000 => x3 <= 750
int: x3_ub = 750;


% Variables
var 0..x1_ub: x1;        % resource allocation for project X1 (integer units)
var 0..x2_ub: x2;        % resource allocation for project X2 (integer units)
var x3_lb..x3_ub: x3;    % resource allocation for project X3 (integer units)
var int: total_cost;     % objective value: total cost


% Constraints
% Link objective variable to decision variables
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% Budget / capacity constraint: x1 + 2*x2 <= 1000
constraint x1 + 2 * x2 <= rhs_1;

% Minimum initiative / feasibility constraint: x2 + 3*x3 >= 600
constraint x2 + 3 * x3 >= rhs_2;

% Strategic balance equality constraint: 2*x3 - x1 = 500
constraint 2 * x3 - x1 = rhs_3;


% Objective
solve minimize total_cost;