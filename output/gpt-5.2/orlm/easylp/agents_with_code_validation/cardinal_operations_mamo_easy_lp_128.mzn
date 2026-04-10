% Parameters
int: costX = 20;              % Cost per unit of Project X (planting trees)
int: costY = 30;              % Cost per unit of Project Y (cleaning rivers)
int: effX = 3;                % Effectiveness contribution per unit of X
int: effY = 1;                % Effectiveness contribution per unit of Y
int: minEffectiveness = 10;   % Minimum required effectiveness score
int: manpowerX = 1;           % Capacity weight per unit of X
int: manpowerY = 5;           % Capacity weight per unit of Y
int: maxCapacity = 50;        % Maximum allowed total capacity

% Variables
var 0..maxCapacity: x;                      % Units of Project X (nonnegative integer)
var 0..(maxCapacity div manpowerY): y;      % Units of Project Y (nonnegative integer)
var 0..(costX*maxCapacity + costY*(maxCapacity div manpowerY)): totalCost; % Total cost

% Constraints
constraint totalCost = costX * x + costY * y;                 % Cost accounting
constraint effX * x + effY * y >= minEffectiveness;           % Effectiveness requirement
constraint manpowerX * x + manpowerY * y <= maxCapacity;      % Capacity constraint

% Objective
solve minimize totalCost;