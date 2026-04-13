% Parameters
int: costX = 10;                 % Cost per unit of product X ($/unit)
int: costY = 15;                 % Cost per unit of product Y ($/unit)
int: costZ = 20;                 % Cost per unit of product Z ($/unit)

int: maxXY = 5000;               % Upper bound on combined production of X and Y
int: maxYZ = 4000;               % Upper bound on combined production of Y and Z
int: minXZ = 2000;               % Lower bound on combined production of X and Z

% Variables
var 0..maxXY: x;                 % Units produced of product X (nonnegative integer)
var 0..min(maxXY, maxYZ): y;     % Units produced of product Y (bounded by both pairwise caps)
var 0..maxYZ: z;                 % Units produced of product Z (nonnegative integer)

% Constraints
% Capacity constraint: combined production of X and Y cannot exceed maxXY
constraint x + y <= maxXY;

% Capacity constraint: combined production of Y and Z cannot exceed maxYZ
constraint y + z <= maxYZ;

% Demand constraint: combined production of X and Z must be at least minXZ
constraint x + z >= minXZ;

% Objective
solve minimize costX * x + costY * y + costZ * z;