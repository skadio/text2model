% Parameters
int: budget = 1000;                  % Maximum total investment across X, Y, Z
int: min_expr1 = 10;                 % Minimum required value of (3*X + 2*Y - Z)
int: min_expr2 = 30;                 % Minimum required value of (Z - Y)

int: costX = 5;                      % Cost per unit invested in X
int: costY = 6;                      % Cost per unit invested in Y
int: costZ = 7;                      % Cost per unit invested in Z

int: maxX = 500;                     % Maximum allowable investment in X
int: maxY = 400;                     % Maximum allowable investment in Y
int: minZ = 50;                      % Minimum required investment in Z

% Variables
var 0..maxX: investX;                % Units invested in portfolio X (integer)
var 0..maxY: investY;                % Units invested in portfolio Y (integer)
var minZ..budget: investZ;           % Units invested in portfolio Z (integer, at least minZ)

% Upper bound is a safe over-approximation given variable domains
var 0..(costX*maxX + costY*maxY + costZ*budget): total_cost;  % Total cost to minimize

% Constraints

% Budget limit: total investment across X, Y, Z cannot exceed the overall budget
constraint investX + investY + investZ <= budget;

% Diversification / exposure constraint: (3*X + 2*Y - Z) must be at least the required minimum
constraint 3 * investX + 2 * investY - investZ >= min_expr1;

% Exposure difference constraint: Z - Y must be at least the required minimum
constraint investZ - investY >= min_expr2;

% Total cost definition: total_cost equals the weighted sum of investments by their unit costs
constraint total_cost = costX * investX + costY * investY + costZ * investZ;

% Objective
solve minimize total_cost;