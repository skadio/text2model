% Parameters
int: benefit_X = 4;
int: benefit_Y = 3;

int: a1 = 2;   % coefficient of X in constraint 1
int: b1 = 1;   % coefficient of Y in constraint 1
int: rhs1 = 10;

int: a2 = 1;   % coefficient of X in constraint 2
int: b2 = 3;   % coefficient of Y in constraint 2
int: rhs2 = 30;

% Bounds (non-negative allocations)
int: X_ub = rhs2 div a2; % from X + 3Y <= 30, max X when Y=0
int: Y_ub = rhs2 div b2; % from X + 3Y <= 30, max Y when X=0

% Variables
var 0..X_ub: X;
var 0..Y_ub: Y;

var 0..(benefit_X * X_ub + benefit_Y * Y_ub): total_benefit;

% Constraints
constraint a1 * X + b1 * Y >= rhs1;
constraint a2 * X + b2 * Y <= rhs2;

constraint total_benefit = benefit_X * X + benefit_Y * Y;

% Objective
solve minimize total_benefit;