% Parameters
% Costs per unit resource for each project (given in problem statement)
int: cost_x1 = 100;
int: cost_x2 = 150;
int: cost_x3 = 80;
int: cost_x4 = 50;

% Coefficients and RHS values (constraint 4 scaled by 2 to avoid fractional coefficients)
% Constraint 1: 3*x1 + 2*x2 - x3 <= 5000
int: c1_a1 = 3;
int: c1_a2 = 2;
int: c1_a3 = -1;
int: c1_a4 = 0;
int: c1_rhs = 5000;

% Constraint 2: -x1 + 4*x2 + 0*x3 + x4 >= 2000
int: c2_a1 = -1;
int: c2_a2 = 4;
int: c2_a3 = 0;
int: c2_a4 = 1;
int: c2_rhs = 2000;

% Constraint 3: -x1 - x2 + 5*x3 - x4 == 4000
int: c3_a1 = -1;
int: c3_a2 = -1;
int: c3_a3 = 5;
int: c3_a4 = -1;
int: c3_rhs = 4000;

% Constraint 4: -x1 + 6*x2 + 7.5*x3 - 8.5*x4 <= 3000
% Multiply by 2: -2*x1 + 12*x2 + 15*x3 - 17*x4 <= 6000
int: c4_a1 = -2;
int: c4_a2 = 12;
int: c4_a3 = 15;
int: c4_a4 = -17;
int: c4_rhs = 6000;


% Variables
% Resource allocations (whole numbers; non-negativity enforced via constraints below)
var int: x1; % allocation to project X1
var int: x2; % allocation to project X2
var int: x3; % allocation to project X3
var int: x4; % allocation to project X4

% Total cost to minimize
var int: total_cost; % 100*x1 + 150*x2 + 80*x3 + 50*x4


% Constraints
% --- Integrality / non-negativity (resource allocations) ---
constraint x1 >= 0;
constraint x2 >= 0;
constraint x3 >= 0;
constraint x4 >= 0;

% --- Linear feasibility constraints from the problem statement ---
% Constraint 1: 3*x1 + 2*x2 - x3 <= 5000
constraint c1_a1 * x1 + c1_a2 * x2 + c1_a3 * x3 + c1_a4 * x4 <= c1_rhs;

% Constraint 2: -x1 + 4*x2 + x4 >= 2000
constraint c2_a1 * x1 + c2_a2 * x2 + c2_a3 * x3 + c2_a4 * x4 >= c2_rhs;

% Constraint 3: -x1 - x2 + 5*x3 - x4 = 4000
constraint c3_a1 * x1 + c3_a2 * x2 + c3_a3 * x3 + c3_a4 * x4 = c3_rhs;

% Constraint 4 (scaled by 2): -2*x1 + 12*x2 + 15*x3 - 17*x4 <= 6000
constraint c4_a1 * x1 + c4_a2 * x2 + c4_a3 * x3 + c4_a4 * x4 <= c4_rhs;

% --- Total cost definition ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;