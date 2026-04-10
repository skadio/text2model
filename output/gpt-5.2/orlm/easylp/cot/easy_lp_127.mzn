% Parameters (with values embedded)
int: benefitX = 4;
int: benefitY = 3;

int: minImpact = 10;      % 2*X + Y >= 10
int: maxBudget = 30;      % X + 3*Y <= 30

% Variables
var 0..30: X;             % resource units allocated to program X (integer, nonnegative)
var 0..10: Y;             % resource units allocated to program Y (integer, nonnegative), from 3*Y <= 30

var 0..(benefitX*30 + benefitY*10): totalBenefit;

% Constraints
constraint 2*X + Y >= minImpact;
constraint X + 3*Y <= maxBudget;

constraint totalBenefit = benefitX*X + benefitY*Y;

% Objective
solve minimize totalBenefit;