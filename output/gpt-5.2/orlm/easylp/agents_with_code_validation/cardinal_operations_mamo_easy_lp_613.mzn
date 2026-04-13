% Parameters
int: nCrops = 4;                            % number of crop types
set of int: CROPS = 1..nCrops;              % crop index set (1:x1, 2:x2, 3:x3, 4:x4)

array[CROPS] of int: cost = [5, 3, 7, 6];   % cost per acre for each crop
array[CROPS] of int: max_acres = [100, 200, 150, 120]; % maximum acres allowed for each crop

% Resource constraint constants
int: fert_limit = 50;                       % fertilizer limit: 2*x1 + 3*x2 <= 50
int: water_limit = 40;                      % water limit: 4*x1 + x3 <= 40
int: soil_offset = 10;                      % soil constraint offset: 5*x4 >= x2 + 10


% Variables
% Acres planted for each crop (integer decision variables, bounded by per-crop maxima)
array[CROPS] of var 0..200: acres;

% Total planting cost to minimize
var 0..100000: total_cost;


% Constraints
% --- Land restrictions (per-crop maxima)
constraint forall(c in CROPS) (acres[c] <= max_acres[c]);

% --- Define objective variable explicitly
constraint total_cost = sum(c in CROPS)(cost[c] * acres[c]);

% --- Fertilizer availability: 2*x1 + 3*x2 <= 50
constraint 2 * acres[1] + 3 * acres[2] <= fert_limit;

% --- Water supply: 4*x1 + x3 <= 40
constraint 4 * acres[1] + acres[3] <= water_limit;

% --- Soil requirement: 5*x4 >= x2 + 10
constraint 5 * acres[4] >= acres[2] + soil_offset;

% --- Ecological balance: (x1 + x2) - (x3 + x4) = 0
constraint (acres[1] + acres[2]) - (acres[3] + acres[4]) = 0;


% Objective
solve minimize total_cost;