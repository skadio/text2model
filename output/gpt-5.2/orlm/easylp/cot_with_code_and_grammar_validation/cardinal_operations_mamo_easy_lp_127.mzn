% Parameters
int: benefitX = 4;
int: benefitY = 3;

int: a1 = 2;   % coefficient of X in constraint 1
int: b1 = 1;   % coefficient of Y in constraint 1
int: rhs1 = 10;

int: a2 = 1;   % coefficient of X in constraint 2
int: b2 = 3;   % coefficient of Y in constraint 2
int: rhs2 = 30;

% Upper bounds derived from nonnegativity and constraint 2
int: X_ub = rhs2 div a2; % 30
int: Y_ub = rhs2 div b2; % 10

% Variables
var 0..X_ub: X;
var 0..Y_ub: Y;

var 0..(benefitX*X_ub + benefitY*Y_ub): total_benefit;

% Constraints
constraint a1 * X + b1 * Y >= rhs1;
constraint a2 * X + b2 * Y <= rhs2;

constraint total_benefit = benefitX * X + benefitY * Y;

% Objective
solve minimize total_benefit;