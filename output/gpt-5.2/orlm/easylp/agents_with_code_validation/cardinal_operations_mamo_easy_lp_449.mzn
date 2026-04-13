% Parameters
int: costX = 500;                % Cost per unit invested in Project X
int: costY = 1000;               % Cost per unit invested in Project Y

int: minReq = 10;                % Minimum requirement for 5*X + 2*Y
int: maxLimit = 25;              % Maximum limit for 3*X + 4*Y
int: minDiff = 1;                % Minimum required difference between X and Y (X - Y >= 1)

int: x_lb = 0;                   % Lower bound for X
int: x_ub = 7;                   % Upper bound for X
int: y_lb = 0;                   % Lower bound for Y
int: y_ub = 5;                   % Upper bound for Y

% Variables
var x_lb..x_ub: x;               % Integer units invested in Project X
var y_lb..y_ub: y;               % Integer units invested in Project Y
var int: totalCost;              % Total investment cost (to be minimized)

% Constraints
% --- Linear requirement constraints ---
constraint 5 * x + 2 * y >= minReq;        % Minimum requirement: 5X + 2Y >= 10
constraint 3 * x + 4 * y <= maxLimit;      % Maximum limit: 3X + 4Y <= 25

% --- Balance / difference constraint ---
constraint x - y >= minDiff;               % Ensure X exceeds Y by at least minDiff

% --- Total cost definition ---
constraint totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;