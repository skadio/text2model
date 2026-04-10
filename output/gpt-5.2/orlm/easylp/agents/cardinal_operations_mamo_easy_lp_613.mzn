% Parameters
int: nCrops = 4;                                  % number of crops
set of int: CROPS = 1..nCrops;                    % crop index set: 1=x1, 2=x2, 3=x3, 4=x4

array[CROPS] of int: costPerAcre = [5, 3, 7, 6];  % cost units per acre for each crop
array[CROPS] of int: maxAcres    = [100, 200, 150, 120]; % maximum acres for each crop

% Resource / policy constraint constants
int: fertLimit  = 50;                             % fertilizer availability limit
int: waterLimit = 40;                             % water supply limit

% Variables
array[CROPS] of var 0..max(maxAcres): acres;      % acres planted for each crop (whole numbers)
var int: totalCost;                               % total planting cost to minimize

% Constraints
% --- Land restriction constraints (upper bounds per crop) ---
constraint
  forall(c in CROPS) (
    acres[c] <= maxAcres[c]
  );

% --- Fertilizer availability constraint: 2*x1 + 3*x2 <= 50 ---
constraint
  2 * acres[1] + 3 * acres[2] <= fertLimit;

% --- Water supply constraint: 4*x1 + x3 <= 40 ---
constraint
  4 * acres[1] + acres[3] <= waterLimit;

% --- Soil requirement constraint: 5*x4 >= x2 + 10 ---
constraint
  5 * acres[4] >= acres[2] + 10;

% --- Ecological balance constraint: x1 + x2 = x3 + x4 ---
constraint
  acres[1] + acres[2] = acres[3] + acres[4];

% --- Total cost definition ---
constraint
  totalCost = sum(c in CROPS) (costPerAcre[c] * acres[c]);

% Objective
solve minimize totalCost;