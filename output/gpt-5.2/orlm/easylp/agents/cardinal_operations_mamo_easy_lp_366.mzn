% Parameters
% Rental cost per day (USD) for each machinery type
int: costX = 4000;
int: costY = 3000;
int: costZ = 6000;
int: costW = 5000;

% Capacity constraints (upper bounds on combined rentals)
int: maxXY = 50;   % X + Y <= 50
int: maxZW = 40;   % Z + W <= 40

% Requirement constraints (lower bounds on combined rentals)
int: minXZ = 30;   % X + Z >= 30
int: minYW = 20;   % Y + W >= 20

% Individual maximum rentals
int: maxX = 30;
int: maxY = 25;
int: maxZ = 20;
int: maxW = 15;


% Variables
% Number of machines rented of each type (integer, non-negative, bounded by maxima)
var 0..maxX: rentX;
var 0..maxY: rentY;
var 0..maxZ: rentZ;
var 0..maxW: rentW;

% Total daily rental cost (USD), bounded by the maximum possible spend under individual maxima
var 0..(costX*maxX + costY*maxY + costZ*maxZ + costW*maxW): totalCost;


% Constraints

% --- Total cost definition ---
% Link totalCost to the sum of daily rental costs for each machinery type.
constraint
  totalCost = costX * rentX + costY * rentY + costZ * rentZ + costW * rentW;

% --- Combined capacity constraints (budget/availability limits) ---
% Total machines rented from groups (X,Y) and (Z,W) cannot exceed their limits.
constraint
  rentX + rentY <= maxXY;

constraint
  rentZ + rentW <= maxZW;

% --- Project requirement constraints (minimum combined rentals) ---
% Ensure sufficient machinery is rented from required combined groups.
constraint
  rentX + rentZ >= minXZ;

constraint
  rentY + rentW >= minYW;


% Objective
solve minimize totalCost;