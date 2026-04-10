% Parameters (with values embedded)
int: minX = 10;          % $10,000 in thousands
int: minY = 5;           % $5,000 in thousands
int: minTotal = 20;      % $20,000 in thousands
int: maxReturnWeighted = 5000;  % corresponds to $5,000,000 in given scaling
int: costX_perUnit = 100; % $ per (thousand-dollar) unit invested
int: costY_perUnit = 200; % $ per (thousand-dollar) unit invested

% Variables
var minX..maxReturnWeighted: x;  % investment in X (thousands of dollars)
var minY..maxReturnWeighted: y;  % investment in Y (thousands of dollars)

% Constraints
constraint x >= minX;
constraint y >= minY;

% Diversification minimum total investment
constraint x + y >= minTotal;

% Combined investment constraint considering returns (3x + 4y <= 5000)
constraint 3*x + 4*y <= maxReturnWeighted;

% Objective
var int: total_cost = costX_perUnit * x + costY_perUnit * y;
solve minimize total_cost;