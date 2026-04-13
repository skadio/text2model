% Parameters
int: benefit_X = 4;
int: benefit_Y = 3;

int: min_impact = 10;          % 2*X + Y >= 10
int: max_budget = 30;          % X + 3*Y <= 30

% Variables
var 0..max_budget: X;
var 0..max_budget: Y;

var 0..(benefit_X*max_budget + benefit_Y*max_budget): total_benefit;

% Constraints
constraint 2*X + Y >= min_impact;
constraint X + 3*Y <= max_budget;

constraint total_benefit = benefit_X*X + benefit_Y*Y;

% Objective
solve minimize total_benefit;