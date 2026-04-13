% Parameters
% Benefit per unit allocated to each program
int: benefit_X = 4;
int: benefit_Y = 3;

% Constraint coefficients and RHS values
int: a1_X = 2;     % coefficient of X in minimum impact constraint
int: a1_Y = 1;     % coefficient of Y in minimum impact constraint
int: rhs1 = 10;    % minimum required impact

int: a2_X = 1;     % coefficient of X in budget constraint
int: a2_Y = 3;     % coefficient of Y in budget constraint
int: rhs2 = 30;    % maximum budget

% Safe upper bounds for decision variables (derived from budget constraint)
int: X_ub = rhs2 div a2_X;  % X <= 30
int: Y_ub = rhs2 div a2_Y;  % Y <= 10

% Variables
var 0..X_ub: x;  % whole units allocated to program X
var 0..Y_ub: y;  % whole units allocated to program Y

% Total benefit score (objective value), bounded by max possible given domains
var 0..(benefit_X * X_ub + benefit_Y * Y_ub): total_benefit;

% Constraints
% Minimum educational impact requirement: 2*x + y >= 10
constraint a1_X * x + a1_Y * y >= rhs1;

% Budget capacity limit: x + 3*y <= 30
constraint a2_X * x + a2_Y * y <= rhs2;

% Define total benefit score from allocations
constraint total_benefit = benefit_X * x + benefit_Y * y;

% Objective
solve minimize total_benefit;