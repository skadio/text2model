% Parameters
int: cost_X = 500;          % Cost per unit resource allocated to Project X
int: cost_Y = 700;          % Cost per unit resource allocated to Project Y
int: eff_X = 2;             % Effort contribution per unit of X
int: eff_Y = 3;             % Effort contribution per unit of Y
int: min_effort = 2000;     % Minimum required combined effort
int: max_resources = 1500;  % Maximum total resources available

% Variables
var 0..max_resources: x;    % Integer units of resource allocated to Project X
var 0..max_resources: y;    % Integer units of resource allocated to Project Y

% Constraints
% Meet minimum combined effort requirement
constraint eff_X * x + eff_Y * y >= min_effort;

% Respect maximum total resource availability
constraint x + y <= max_resources;

% Objective
solve minimize cost_X * x + cost_Y * y;