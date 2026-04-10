% Parameters (with values embedded)
int: budget_max = 10000;
int: min_X = 2000;   % patient care minimum
int: min_Y = 1500;   % medical research minimum
int: min_Z = 500;    % hospital maintenance minimum

float: eff_X = 0.5;
float: eff_Y = 0.3;
float: eff_Z = 0.2;

% Variables
var min_X..budget_max: X;  % dollars allocated to patient care
var min_Y..budget_max: Y;  % dollars allocated to medical research
var min_Z..budget_max: Z;  % dollars allocated to maintenance

% Constraints
constraint X + Y + Z <= budget_max;

% Objective
% Minimize total cost (total dollars allocated)
solve minimize X + Y + Z;