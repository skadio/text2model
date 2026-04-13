% Feed mix linear program (all data embedded)

int: nFeeds = 5;
set of int: FEEDS = 1..nFeeds;

% Nutritional content per gram of feed
array[FEEDS] of float: protein_g_per_g   = [3.0, 2.0, 1.0, 6.0, 18.0];
array[FEEDS] of float: minerals_g_per_g  = [1.0, 0.5, 0.2, 2.0, 0.5];
array[FEEDS] of float: vitamins_mg_per_g = [0.5, 1.0, 0.2, 2.0, 0.8];

% Prices in ¥/kg from table -> convert to ¥/g
array[FEEDS] of float: price_y_per_kg = [0.2, 0.7, 0.4, 0.3, 0.8];
array[FEEDS] of float: price_y_per_g = [ price_y_per_kg[i] / 1000.0 | i in FEEDS ];

% Daily minimum requirements
float: minProtein_g   = 700.0;
float: minMinerals_g  = 30.0;
float: minVitamins_mg = 100.0;

% Use integer grams to avoid Gecode float-linear limits/issues
array[FEEDS] of var 0..1000000: x_g; % grams/day of each feed (upper bound is safely large)

var float: totalCost;

% Total cost (¥)
constraint totalCost = sum(i in FEEDS)(price_y_per_g[i] * int2float(x_g[i]));

% Nutritional requirement constraints
constraint sum(i in FEEDS)(protein_g_per_g[i]   * int2float(x_g[i])) >= minProtein_g;
constraint sum(i in FEEDS)(minerals_g_per_g[i]  * int2float(x_g[i])) >= minMinerals_g;
constraint sum(i in FEEDS)(vitamins_mg_per_g[i] * int2float(x_g[i])) >= minVitamins_mg;

solve minimize totalCost;