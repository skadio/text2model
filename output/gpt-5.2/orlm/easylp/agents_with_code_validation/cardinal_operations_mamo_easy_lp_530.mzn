% Parameters
% Unit costs
int: cost_x1 = 10;
int: cost_x2 = 15;
int: cost_x3 = 20;

% Constraint coefficients / RHS values
int: a1 = 5;
int: a2 = 7;
int: a3 = 9;
int: min_effectiveness = 5000;

int: b1 = 3;     % coefficient for x2 in constraint 2 (3*x2)
int: rhs2 = 1500;

int: rhs3 = 2000;

% Bounds on allocations
int: x1_lb = 0;
int: x1_ub = 10000;

int: x2_lb = 0;
int: x2_ub = 8000;

int: x3_lb = 0;
int: x3_ub = 6000;


% Variables
var x1_lb..x1_ub: x1; % integer allocation to project X1
var x2_lb..x2_ub: x2; % integer allocation to project X2
var x3_lb..x3_ub: x3; % integer allocation to project X3

% Total cost (bounded above by using allocation upper bounds)
var 0..(cost_x1*x1_ub + cost_x2*x2_ub + cost_x3*x3_ub): total_cost;


% Constraints
% Total cost definition (linear expression)
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% Minimum effectiveness requirement
constraint a1 * x1 + a2 * x2 + a3 * x3 >= min_effectiveness;

% Constraint 2: 3*x2 - x1 - 4*x3 <= 1500
constraint b1 * x2 - x1 - 4 * x3 <= rhs2;

% Constraint 3: x1 - x3 - 2.5*x2 = 2000
% Multiply through by 2 to avoid non-integer coefficients:
% 2*x1 - 2*x3 - 5*x2 = 4000
constraint 2 * x1 - 2 * x3 - 5 * x2 = 2 * rhs3;


% Objective
solve minimize total_cost;