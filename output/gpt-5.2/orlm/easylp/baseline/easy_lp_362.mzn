% Crop planning / minimum cost

int: nFields = 4;
set of int: FIELDS = 1..nFields;

% Total area (acres) to be planted across all fields (embedded data).
% The statement gives only combined-area constraints; we model the decision
% as allocating acres to each crop with integer acres.
int: TOTAL_ACRES = 600;

set of int: CROPS = 1..4;
int: CORN = 1;
int: WHEAT = 2;
int: SOYBEAN = 3;
int: RICE = 4;

array[CROPS] of int: cost = [3, 2, 5, 4];

% Decision: acres allocated to each crop (integer acres)
array[CROPS] of var 0..TOTAL_ACRES: acres;

constraint sum(c in CROPS)(acres[c]) = TOTAL_ACRES;

% Restrictions
constraint acres[CORN] + acres[WHEAT] <= 500;      % cereal restriction
constraint acres[SOYBEAN] + acres[RICE] <= 400;    % water availability
constraint acres[CORN] + acres[SOYBEAN] >= 200;    % legumes requirement (as stated)
constraint acres[WHEAT] + acres[RICE] >= 300;      % grains demand

var int: total_cost = sum(c in CROPS)(cost[c] * acres[c]);

solve minimize total_cost;

output [
  "TOTAL_ACRES=", show(TOTAL_ACRES), "\n",
  "Corn acres=", show(acres[CORN]), " cost=", show(cost[CORN]), "\n",
  "Wheat acres=", show(acres[WHEAT]), " cost=", show(cost[WHEAT]), "\n",
  "Soybean acres=", show(acres[SOYBEAN]), " cost=", show(cost[SOYBEAN]), "\n",
  "Rice acres=", show(acres[RICE]), " cost=", show(cost[RICE]), "\n",
  "Minimum total cost=$", show(total_cost), "\n"
];