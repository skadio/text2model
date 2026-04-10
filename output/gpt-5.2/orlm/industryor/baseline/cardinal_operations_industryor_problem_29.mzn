% Diet / feed mix LP
% Minimize cost while meeting minimum nutrient requirements.

int: nFeeds = 5;
set of int: FEEDS = 1..nFeeds;

% Nutrient content per gram of feed
array[FEEDS] of float: protein_g_per_g   = [3.0, 2.0, 1.0, 6.0, 18.0];
array[FEEDS] of float: minerals_g_per_g  = [1.0, 0.5, 0.2, 2.0, 0.5];
array[FEEDS] of float: vitamins_mg_per_g = [0.5, 1.0, 0.2, 2.0, 0.8];

% Price given as ¥/kg in the table; convert to ¥/g by dividing by 1000
array[FEEDS] of float: price_y_per_kg = [0.2, 0.7, 0.4, 0.3, 0.8];
array[FEEDS] of float: price_y_per_g  = [ price_y_per_kg[i] / 1000.0 | i in FEEDS ];

% Daily minimum requirements
float: req_protein_g  = 700.0;
float: req_minerals_g = 30.0;
float: req_vitamins_mg = 100.0;

% Decision variables: grams of each feed used per day (continuous, nonnegative)
array[FEEDS] of var float: x_g;
constraint forall(i in FEEDS)(x_g[i] >= 0.0);

% Nutrient constraints
constraint sum(i in FEEDS)(protein_g_per_g[i]   * x_g[i]) >= req_protein_g;
constraint sum(i in FEEDS)(minerals_g_per_g[i]  * x_g[i]) >= req_minerals_g;
constraint sum(i in FEEDS)(vitamins_mg_per_g[i] * x_g[i]) >= req_vitamins_mg;

% Objective: minimize total cost (¥)
var float: total_cost = sum(i in FEEDS)(price_y_per_g[i] * x_g[i]);
solve minimize total_cost;

output [
  "Total cost (¥): ", show(total_cost), "\n",
  "Feed amounts (g):\n",
  concat([ "  Feed ", show(i), ": ", show(x_g[i]), "\n" | i in FEEDS ])
];