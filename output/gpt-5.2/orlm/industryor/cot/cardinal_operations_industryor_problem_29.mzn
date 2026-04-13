% Parameters (with values embedded)
int: N = 5;
set of int: FEEDS = 1..N;

% Nutritional content per gram of feed
array[FEEDS] of float: protein_g_per_g  = [3.0, 2.0, 1.0, 6.0, 18.0];
array[FEEDS] of float: minerals_g_per_g = [1.0, 0.5, 0.2, 2.0, 0.5];
array[FEEDS] of float: vitamins_mg_per_g= [0.5, 1.0, 0.2, 2.0, 0.8];

% Price (¥/kg) -> convert to ¥/g by dividing by 1000
array[FEEDS] of float: price_y_per_kg = [0.2, 0.7, 0.4, 0.3, 0.8];
array[FEEDS] of float: price_y_per_g = [ price_y_per_kg[i] / 1000.0 | i in FEEDS ];

% Daily minimum requirements
float: req_protein_g  = 700.0;
float: req_minerals_g = 30.0;
float: req_vitamins_mg= 100.0;

% Variables
array[FEEDS] of var float: x_g;        % grams of each feed selected per day
var float: total_cost;

% Constraints
constraint forall(i in FEEDS) ( x_g[i] >= 0.0 );

constraint sum(i in FEEDS) (protein_g_per_g[i]  * x_g[i]) >= req_protein_g;
constraint sum(i in FEEDS) (minerals_g_per_g[i] * x_g[i]) >= req_minerals_g;
constraint sum(i in FEEDS) (vitamins_mg_per_g[i]* x_g[i]) >= req_vitamins_mg;

constraint total_cost = sum(i in FEEDS) (price_y_per_g[i] * x_g[i]);

% Objective
solve minimize total_cost;