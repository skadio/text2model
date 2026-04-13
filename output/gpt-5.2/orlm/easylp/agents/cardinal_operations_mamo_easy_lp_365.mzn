% Parameters

% Crop set
set of int: CROPS = 1..4;

% Indices for readability
int: WHEAT   = 1;
int: CORN    = 2;
int: RICE    = 3;
int: SOYBEAN = 4;

% Capacity / requirement totals (all embedded as per instructions)
int: max_wheat_corn = 50;      % wheat + corn <= 50
int: max_rice_soy   = 30;      % rice + soybean <= 30
int: min_wheat_rice = 20;      % wheat + rice >= 20
int: min_corn_soy   = 15;      % corn + soybean >= 15

% Unit planting costs ($/unit), aligned with CROPS indexing
array[CROPS] of int: cost = [4, 3, 2, 1];

% Simple global upper bound on any single crop from combined limits (50 is the largest)
int: max_units_per_crop = 50;


% Variables

% Integer units planted of each crop
array[CROPS] of var 0..max_units_per_crop: plant;

% Total planting cost in dollars
var int: total_cost;


% Constraints

% --- Crop combination capacity constraints ---

% Land capacity for wheat + corn
constraint plant[WHEAT] + plant[CORN] <= max_wheat_corn;

% Land capacity for rice + soybean
constraint plant[RICE] + plant[SOYBEAN] <= max_rice_soy;

% --- Soil health / minimum planting requirements ---

% Minimum combined planting of wheat + rice
constraint plant[WHEAT] + plant[RICE] >= min_wheat_rice;

% Minimum combined planting of corn + soybean
constraint plant[CORN] + plant[SOYBEAN] >= min_corn_soy;

% --- Total cost definition ---

% Define total_cost as the sum of unit costs times planted units
constraint total_cost = sum(c in CROPS)(cost[c] * plant[c]);


% Objective
solve minimize total_cost;