% Parameters
% Cost coefficients (units per resource allocated)
int: cost_x1 = 4;
int: cost_x2 = 5;
int: cost_x3 = 6;
int: cost_x4 = 7;

% Resource allocation bounds for each project
int: x1_lb = 0;   int: x1_ub = 100;
int: x2_lb = 0;   int: x2_ub = 80;
int: x3_lb = 0;   int: x3_ub = 60;
int: x4_lb = 0;   int: x4_ub = 70;

% Constraint RHS values
int: rhs1 = 50;
int: rhs2 = 20;
int: rhs3 = 30;
int: rhs4 = 10;

% Variables
% Resource allocations (must be whole numbers)
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

% Total cost (bounded explicitly for better propagation)
var 0..(cost_x1*x1_ub + cost_x2*x2_ub + cost_x3*x3_ub + cost_x4*x4_ub): total_cost;

% Constraints
% Cost aggregation (link decision variables to total cost)
constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;

% Budget/operational constraint 1: x1 + 2*x2 <= 50
constraint x1 + 2 * x2 <= rhs1;

% Budget/operational constraint 2: 3*x3 - x4 >= 20
constraint 3 * x3 - x4 >= rhs2;

% Budget/operational constraint 3: x2 + x3 - x1 <= 30
constraint x2 + x3 - x1 <= rhs3;

% Budget/operational constraint 4: 3*x4 - x2 >= 10
constraint 3 * x4 - x2 >= rhs4;

% Objective
solve minimize total_cost;