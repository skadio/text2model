% Parameters
int: cost_X = 5;                 % Cost per unit of product X ($)
int: cost_Y = 10;                % Cost per unit of product Y ($)

int: resCoef_X = 2;              % Coefficient for X in resource/labor upper-bound constraint
int: resCoef_Y = 3;              % Coefficient for Y in resource/labor upper-bound constraint
int: resLimit  = 100;            % Upper bound on combined resource/labor usage

int: demCoef_X = 4;              % Coefficient for X in demand lower-bound constraint
int: demCoef_Y = 1;              % Coefficient for Y in demand lower-bound constraint
int: demMin    = 50;             % Minimum required demand expression value

% Variables
var 0..(resLimit div resCoef_X): x;    % Units of product X (nonnegative integer)
var 0..(resLimit div resCoef_Y): y;    % Units of product Y (nonnegative integer)

% Total cost upper bound from max possible x and y within their individual bounds
var 0..(cost_X*(resLimit div resCoef_X) + cost_Y*(resLimit div resCoef_Y)): total_cost;

% Constraints
% Resource/labor availability (upper bound)
constraint resCoef_X * x + resCoef_Y * y <= resLimit;

% Market demand requirement (lower bound)
constraint demCoef_X * x + demCoef_Y * y >= demMin;

% Define total production cost from unit costs and quantities
constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;