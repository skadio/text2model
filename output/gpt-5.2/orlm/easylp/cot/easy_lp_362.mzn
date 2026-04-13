% Parameters (with values embedded)
int: nFields = 4;

set of int: CROPS = 1..4;
int: Corn = 1;
int: Wheat = 2;
int: Soybean = 3;
int: Rice = 4;

array[CROPS] of int: cost_per_acre = [3, 2, 5, 4];

% NOTE: The problem statement does not provide the acreage of each of the 4 fields.
% To keep the model self-contained and consistent, we model decision variables as the
% total acres planted with each crop (integer), with constraints given in the text.

% Variables
array[CROPS] of var 0..10000: acres; % acres[c] = total acres planted with crop c

% Constraints
constraint acres[Corn] + acres[Wheat] <= 500;     % cereal cap
constraint acres[Soybean] + acres[Rice] <= 400;   % water cap

constraint acres[Corn] + acres[Soybean] >= 200;   % legumes minimum (as stated)
constraint acres[Wheat] + acres[Rice] >= 300;     % grains minimum

% Objective
var int: total_cost = sum(c in CROPS)(cost_per_acre[c] * acres[c]);
solve minimize total_cost;