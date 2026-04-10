% Parameters
int: budget = 10000;                 % Total available budget

int: minX = 200;                     % Minimum investment in portfolio X
int: maxX = 5000;                    % Maximum investment in portfolio X

int: minY = 100;                     % Minimum investment in portfolio Y
int: maxY = 4000;                    % Maximum investment in portfolio Y

int: minZ = 800;                     % Minimum investment in portfolio Z
int: maxZ = budget;                  % No explicit max given for Z; bounded by budget

int: rhs_invest_diff = 3000;         % RHS for constraint: X - 2Y + Z >= 3000

% Percent-return/loss coefficients (scaled by 100 to keep integers):
% 0.07*X - 0.02*Y - 0.05*Z >= 0  <=>  7X - 2Y - 5Z >= 0
int: coefX = 7;
int: coefY = -2;
int: coefZ = -5;

% Cost per dollar invested
int: costX = 50;
int: costY = 30;
int: costZ = 20;

% Variables
var minX..maxX: investX;             % Dollars invested in portfolio X (integer)
var minY..maxY: investY;             % Dollars invested in portfolio Y (integer)
var minZ..maxZ: investZ;             % Dollars invested in portfolio Z (integer)

% Upper bound based on variable bounds (safe, though loose)
var 0..(costX*maxX + costY*maxY + costZ*maxZ): totalCost;  % Total cost to minimize

% Constraints

% Budget constraint: total investment cannot exceed available budget
constraint
  investX + investY + investZ <= budget;

% Portfolio viability / bounds (already enforced by variable domains, kept for clarity)
constraint
  investX >= minX /\ investX <= maxX;
constraint
  investY >= minY /\ investY <= maxY;
constraint
  investZ >= minZ /\ investZ <= maxZ;

% Non-negative combined return constraint:
% 0.07*X - 0.02*Y - 0.05*Z >= 0  <=>  7X - 2Y - 5Z >= 0
constraint
  coefX * investX + coefY * investY + coefZ * investZ >= 0;

% Investment difference constraint: X - 2Y + Z >= 3000
constraint
  investX - 2 * investY + investZ >= rhs_invest_diff;

% Total cost definition
constraint
  totalCost = costX * investX + costY * investY + costZ * investZ;

% Objective
solve minimize totalCost;