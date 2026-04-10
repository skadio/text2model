% Parameters
% Cost coefficients for projects x1, x2, x3
int: c1 = 5;
int: c2 = 3;
int: c3 = 7;

% Allocation bounds (inclusive)
int: x1_lb = 0;
int: x1_ub = 15;

int: x2_lb = 0;
int: x2_ub = 10;

int: x3_lb = 0;
int: x3_ub = 8;

% Constraint right-hand-sides
int: rhs1 = 10;  % 2*x1 + x2 >= 10
int: rhs2 = 20;  % x1 + 3*x3 <= 20
int: rhs3 = 5;   % x2 - 4*x3 >= 5


% Variables
% Integer resource allocations to each project within given bounds
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;

% Total cost (bounded using variable bounds)
% min cost = 0, max cost = 5*15 + 3*10 + 7*8 = 161
var 0..161: total_cost;


% Constraints
% --- Linear resource/budget constraints ---
constraint 2 * x1 + x2 >= rhs1;   % Minimum combined allocation requirement
constraint x1 + 3 * x3 <= rhs2;   % Upper limit on x1 and x3 combined impact
constraint x2 - 4 * x3 >= rhs3;   % Minimum net allocation relationship between x2 and x3

% --- Total cost definition ---
constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3;  % Compute total cost from allocations


% Objective
solve minimize total_cost;