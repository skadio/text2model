% Parameters
int: costX = 5;                 % Cost per vehicle of type X
int: costY = 4;                 % Cost per vehicle of type Y
int: costZ = 3;                 % Cost per vehicle of type Z

int: maxTotalVehicles = 1000;   % Upper bound on total number of vehicles
int: min_2X_plus_Y = 200;       % Lower bound on 2*X + Y
int: max_X_plus_Z = 300;        % Upper bound on X + Z

% Variables
var 0..maxTotalVehicles: numX;  % Number of vehicles of type X (integer, nonnegative)
var 0..maxTotalVehicles: numY;  % Number of vehicles of type Y (integer, nonnegative)
var 0..maxTotalVehicles: numZ;  % Number of vehicles of type Z (integer, nonnegative)

var 0..(costX*maxTotalVehicles + costY*maxTotalVehicles + costZ*maxTotalVehicles): totalCost;
                               % Total operating cost (upper-bounded for safe linear modeling)

% Constraints
% --- Total vehicle limit (budget/operational cap) ---
constraint numX + numY + numZ <= maxTotalVehicles;

% --- Minimum service requirement: 2*X + Y must be at least the required level ---
constraint 2 * numX + numY >= min_2X_plus_Y;

% --- Fleet composition restriction: X + Z cannot exceed the maximum allowed ---
constraint numX + numZ <= max_X_plus_Z;

% --- Define total cost from chosen vehicle counts ---
constraint totalCost = costX * numX + costY * numY + costZ * numZ;

% Objective
solve minimize totalCost;