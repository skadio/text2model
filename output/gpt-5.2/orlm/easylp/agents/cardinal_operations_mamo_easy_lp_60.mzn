% Parameters
int: costX = 2000;                 % Cost per resource unit for Project X (dollars)
int: costY = 3000;                 % Cost per resource unit for Project Y (dollars)

int: perfCoeffX = 5;               % Performance coefficient for X
int: perfCoeffY = 10;              % Performance coefficient for Y
int: minPerformance = 50;          % Minimum required performance score

int: usageCoeffX = 3;              % Resource-usage coefficient for X
int: usageCoeffY = 4;              % Resource-usage coefficient for Y
int: maxUsage = 40;                % Maximum allowed total usage

% Safe explicit upper bounds from maxUsage constraint with non-negativity:
% 3*X + 4*Y <= 40 => X <= 13, Y <= 10 (integer floors)
int: maxX = 13;
int: maxY = 10;

% Variables
var 0..maxX: x;                    % Integer resource units allocated to Project X
var 0..maxY: y;                    % Integer resource units allocated to Project Y

var 0..(costX*maxX + costY*maxY): totalCost;   % Total cost (dollars), bounded

% Constraints
% Performance requirement: ensure combined performance meets minimum target
constraint
  perfCoeffX * x + perfCoeffY * y >= minPerformance;

% Resource usage limit: ensure total usage does not exceed availability
constraint
  usageCoeffX * x + usageCoeffY * y <= maxUsage;

% Total cost definition: link decision variables to computed total cost
constraint
  totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;