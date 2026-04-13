% Parameters
% Crop indices: 1=Wheat, 2=Corn, 3=Rice, 4=Barley
set of int: CROPS = 1..4;

int: Wheat  = 1;
int: Corn   = 2;
int: Rice   = 3;
int: Barley = 4;

% Pairwise land caps
int: max_wheat_corn  = 500;  % Wheat + Corn <= 500
int: max_rice_barley = 600;  % Rice + Barley <= 600

% Diversity / demand minimum differences
int: min_wheat_minus_rice  = 100; % Wheat >= Rice + 100
int: min_corn_minus_barley = 200; % Corn  >= Barley + 200

% Cost per acre (USD)
array[CROPS] of int: cost_per_acre = [10, 20, 30, 40];

% Since crop-specific bounds are not provided, use conservative implied bounds
int: min_acres = 0;
int: max_acres = max(max_wheat_corn, max_rice_barley); % 600


% Variables
array[CROPS] of var min_acres..max_acres: acres;  % integer acres allocated to each crop
var int: total_cost;                              % total cultivation cost (USD)


% Constraints
% Land availability caps for crop pairs
constraint acres[Wheat] + acres[Corn] <= max_wheat_corn;
constraint acres[Rice]  + acres[Barley] <= max_rice_barley;

% Minimum difference requirements (diversity / demand)
constraint acres[Wheat] >= acres[Rice] + min_wheat_minus_rice;
constraint acres[Corn]  >= acres[Barley] + min_corn_minus_barley;

% Total cost definition (USD)
constraint total_cost = sum(c in CROPS)(cost_per_acre[c] * acres[c]);


% Objective
solve minimize total_cost;