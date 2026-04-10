% Parameters
% Costs per unit resource for projects x1..x4
int: cost_x1 = 100;
int: cost_x2 = 150;
int: cost_x3 = 80;
int: cost_x4 = 50;

% Constraint right-hand sides
int: rhs1 = 5000;   % 3*x1 + 2*x2 - x3 <= 5000
int: rhs2 = 2000;   % -x1 + 4*x2 + x4 >= 2000
int: rhs3 = 4000;   % -x1 - x2 + 5*x3 - x4 == 4000
int: rhs4 = 3000;   % -x1 + 6*x2 + 7.5*x3 - 8.5*x4 <= 3000

% Variable bounds
% NOTE: The description mentions "specific bounds" but does not provide them.
% We assume nonnegative integer allocations and use a safe upper bound.
int: UB = 100000;

% Variables
var 0..UB: x1;  % integer resources allocated to project X1
var 0..UB: x2;  % integer resources allocated to project X2
var 0..UB: x3;  % integer resources allocated to project X3
var 0..UB: x4;  % integer resources allocated to project X4


% Constraints

% (1) 3*x1 + 2*x2 - x3 <= 5000
constraint 3*x1 + 2*x2 - x3 <= rhs1;

% (2) -x1 + 4*x2 + x4 >= 2000
constraint -x1 + 4*x2 + x4 >= rhs2;

% (3) -x1 - x2 + 5*x3 - x4 == 4000
constraint -x1 - x2 + 5*x3 - x4 = rhs3;

% (4) -x1 + 6*x2 + 7.5*x3 - 8.5*x4 <= 3000
% Multiply by 2 to remove fractional coefficients:
% -2*x1 + 12*x2 + 15*x3 - 17*x4 <= 6000
constraint -2*x1 + 12*x2 + 15*x3 - 17*x4 <= 2*rhs4;


% Objective
solve minimize cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;