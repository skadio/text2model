% Parameters
int: costX = 1000;            % Cost per unit for Project X (air)
int: costY = 500;             % Cost per unit for Project Y (water)
int: costZ = 1200;            % Cost per unit for Project Z (land)

int: total_units_max = 100;   % Maximum total units across all projects

int: X_min = 0;               % Lower bound on units for Project X
int: X_max = 50;              % Upper bound on units for Project X
int: Y_min = 0;               % Lower bound on units for Project Y
int: Y_max = 40;              % Upper bound on units for Project Y
int: Z_min = 0;               % Lower bound on units for Project Z
int: Z_max = 60;              % Upper bound on units for Project Z

int: X_at_least_Y_plus = 10;  % X must be at least this many units more than Y
int: Z_at_most_Y_plus = 20;   % Z cannot exceed Y by more than this many units

% Variables
var X_min..X_max: unitsX;      % Integer units allocated to Project X
var Y_min..Y_max: unitsY;      % Integer units allocated to Project Y
var Z_min..Z_max: unitsZ;      % Integer units allocated to Project Z

% Upper bound: maximum possible cost given variable bounds
var 0..(costX*X_max + costY*Y_max + costZ*Z_max): totalCost;

% Constraints
% Linear cost definition
constraint totalCost = costX * unitsX + costY * unitsY + costZ * unitsZ;

% Budgetary limitation on total units
constraint unitsX + unitsY + unitsZ <= total_units_max;

% Balance: X at least 10 more than Y
constraint unitsX >= unitsY + X_at_least_Y_plus;

% Balance: Z no more than 20 above Y
constraint unitsZ <= unitsY + Z_at_most_Y_plus;

% Objective
solve minimize totalCost;