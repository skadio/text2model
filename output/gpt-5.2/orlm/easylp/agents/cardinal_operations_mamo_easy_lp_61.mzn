% Parameters
int: effortCoeffX = 5;          % Effort coefficient for Task X in minimum-effort constraint
int: effortCoeffY = 10;         % Effort coefficient for Task Y in minimum-effort constraint
int: minTotalEffort = 50;       % Minimum required total effort

int: qualityCoeffX = 3;         % Effort coefficient for Task X in quality (maximum) constraint
int: qualityCoeffY = 4;         % Effort coefficient for Task Y in quality (maximum) constraint
int: maxQualityEffort = 36;     % Maximum allowed combined effort for quality standard

int: costX = 20;                % Cost per unit resource allocated to Task X (dollars)
int: costY = 30;                % Cost per unit resource allocated to Task Y (dollars)

% Variables
var 0..1000: x;                 % Integer units of resources allocated to Task X
var 0..1000: y;                 % Integer units of resources allocated to Task Y
var 0..1000000: totalCost;      % Total cost in dollars

% Constraints
% Link totalCost to decision variables (cost accounting)
constraint totalCost = costX * x + costY * y;

% Minimum total effort requirement
constraint effortCoeffX * x + effortCoeffY * y >= minTotalEffort;

% Quality standard: maximum allowed combined effort
constraint qualityCoeffX * x + qualityCoeffY * y <= maxQualityEffort;

% Objective
solve minimize totalCost;