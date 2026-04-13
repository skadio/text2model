% Parameters
int: budget = 10000;                 % Total investment budget (max total dollars)

int: minX = 200;                     % Minimum investment in portfolio X
int: maxX = 5000;                    % Maximum investment in portfolio X

int: minY = 100;                     % Minimum investment in portfolio Y
int: maxY = 4000;                    % Maximum investment in portfolio Y

int: minZ = 800;                     % Minimum investment in portfolio Z
int: maxZ = budget;                  % Safe upper bound for Z (no explicit limit given)

% Return coefficients (scaled by 100 to avoid floats):
% 0.07*X - 0.02*Y - 0.05*Z >= 0  <=>  7*X - 2*Y - 5*Z >= 0
int: retX = 7;
int: retY = -2;
int: retZ = -5;

int: diffRHS = 3000;                 % Constraint RHS: X - 2Y + Z >= 3000

int: costX = 50;                     % Cost per dollar invested in X
int: costY = 30;                     % Cost per dollar invested in Y
int: costZ = 20;                     % Cost per dollar invested in Z


% Variables
var minX..maxX: investX;             % Dollars invested in portfolio X (integer)
var minY..maxY: investY;             % Dollars invested in portfolio Y (integer)
var minZ..maxZ: investZ;             % Dollars invested in portfolio Z (integer)

var 0..(maxX + maxY + maxZ): totalInvestment; 
var 0..(costX*maxX + costY*maxY + costZ*maxZ): totalCost;


% Constraints
% --- Total investment accounting and budget limit ---
constraint totalInvestment = investX + investY + investZ;
constraint totalInvestment <= budget;

% --- Return (non-negative) constraint: 7*X - 2*Y - 5*Z >= 0 ---
constraint retX * investX + retY * investY + retZ * investZ >= 0;

% --- Difference constraint: X - 2Y + Z >= 3000 ---
constraint investX - 2 * investY + investZ >= diffRHS;

% --- Total cost accounting ---
constraint totalCost = costX * investX + costY * investY + costZ * investZ;


% Objective
solve minimize totalCost;