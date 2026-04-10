% Parameters
int: budget = 1000;                 % Maximum total investment units across X, Y, Z
int: min_strength = 400;            % Minimum required combined strength: 3*X + 2*Y >= 400
int: max_diff_ZY = 300;             % Maximum allowed absolute difference |Z - Y|

int: costX = 300;                   % Cost per unit of X
int: costY = 500;                   % Cost per unit of Y
int: costZ = 200;                   % Cost per unit of Z

% Variables
var 0..budget: x;                   % Units allocated to project X
var 0..budget: y;                   % Units allocated to project Y
var 0..budget: z;                   % Units allocated to project Z

% Upper bound is the maximum possible cost if each variable took value 'budget'
var 0..(costX*budget + costY*budget + costZ*budget): total_cost;

% Constraints
% Budget limit: total investment across X, Y, Z cannot exceed available budget
constraint x + y + z <= budget;

% Minimum strength requirement
constraint 3 * x + 2 * y >= min_strength;

% Balance constraint between Z and Y
constraint abs(z - y) <= max_diff_ZY;

% Dominance constraint: X strictly greater than twice Z
constraint x > 2 * z;

% Total cost definition
constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;