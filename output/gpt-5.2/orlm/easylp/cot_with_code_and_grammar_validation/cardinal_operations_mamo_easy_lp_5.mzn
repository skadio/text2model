% Parameters
int: max_budget = 1000;
int: min_effectiveness = 2000;

int: eff_X = 2;
int: eff_Y = 3;

int: cost_X = 10;
int: cost_Y = 20;

% Variables
var 0..max_budget: X;
var 0..max_budget: Y;

% Constraints
constraint X + Y <= max_budget;

constraint eff_X * X + eff_Y * Y >= min_effectiveness;

% Objective
solve minimize cost_X * X + cost_Y * Y;