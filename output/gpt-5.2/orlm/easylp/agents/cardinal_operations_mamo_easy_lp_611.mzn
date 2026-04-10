% Parameters
% Crop indices: 1=Wheat, 2=Corn, 3=Rice, 4=Barley
int: nCrops = 4;
set of int: CROPS = 1..nCrops;

int: WHEAT  = 1;
int: CORN   = 2;
int: RICE   = 3;
int: BARLEY = 4;

% Combined-area limits (acres)
int: maxWheatCorn   = 500;
int: maxRiceBarley  = 600;

% Minimum difference constraints (acres)
int: minWheatMinusRice   = 100;
int: minCornMinusBarley  = 200;

% Cost per acre (dollars)
array[CROPS] of int: costPerAcre = [10, 20, 30, 40];

% NOTE: The statement mentions "each crop has specific bounds on land allocation"
% but does not provide numeric bounds. Hence, only non-negativity is enforced.

% Variables
% Acres allocated to each crop (whole acres)
array[CROPS] of var int: acres;

% Total cost (dollars)
var int: totalCost;

% Constraints
% Non-negativity (whole acres already ensured by var int)
constraint forall(c in CROPS) (acres[c] >= 0);

% Combined area limits
constraint acres[WHEAT] + acres[CORN] <= maxWheatCorn;
constraint acres[RICE]  + acres[BARLEY] <= maxRiceBarley;

% Minimum difference constraints
constraint acres[WHEAT] - acres[RICE] >= minWheatMinusRice;
constraint acres[CORN]  - acres[BARLEY] >= minCornMinusBarley;

% Total cost definition
constraint totalCost = sum(c in CROPS)(costPerAcre[c] * acres[c]);

% Objective
solve minimize totalCost;