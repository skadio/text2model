% Parameters
% Budget limit (in dollars)
int: totalBudget = 5000;

% Minimum gap between X and Y (X at least this much more than Y)
int: minXYGap = 50;

% Bounds on how far Z can differ from X and Y respectively
int: maxZXDiff = 1000;   % |Z - X| <= 1000
int: maxZYDiff = 200;    % |Z - Y| <= 200

% Unit costs (cost per unit impact) for each channel
int: unitCostX = 500;
int: unitCostY = 300;
int: unitCostZ = 1000;

% Maximum investment allowed per channel (in dollars)
int: maxX = 2500;
int: maxY = 1500;
int: maxZ = 4000;


% Variables
% Dollar allocations to each advertising channel (whole dollars)
var 0..maxX: allocX;
var 0..maxY: allocY;
var 0..maxZ: allocZ;

% Total allocation (bounded by totalBudget)
var 0..totalBudget: totalAlloc;

% Total cost to minimize (bounded using max possible spend)
% Upper bound = 500*2500 + 300*1500 + 1000*4000 = 5,700,000
var 0..5700000: totalCost;


% Constraints
% --- Budget and total allocation accounting ---
constraint totalAlloc = allocX + allocY + allocZ;
constraint totalAlloc <= totalBudget;

% --- Relative allocation requirement between X and Y ---
% X must be at least minXYGap dollars more than Y
constraint allocX >= allocY + minXYGap;

% --- Strategic difference constraints involving Z ---
% Z must be within maxZXDiff dollars of X
constraint abs(allocZ - allocX) <= maxZXDiff;

% Z must be within maxZYDiff dollars of Y
constraint abs(allocZ - allocY) <= maxZYDiff;

% --- Total cost calculation (for objective use elsewhere) ---
constraint totalCost = unitCostX * allocX + unitCostY * allocY + unitCostZ * allocZ;


% Objective
solve minimize totalCost;