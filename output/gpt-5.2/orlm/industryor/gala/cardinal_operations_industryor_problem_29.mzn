% Diet / feed mix linear program (implemented as MILP with gram units)
% Data embedded from the problem statement.

include "globals.mzn";

int: n = 5;
set of int: FEED = 1..n;

% Nutrient content per gram of feed
array[FEED] of int: protein_g_per_g  = [3, 2, 1, 6, 18];     % g protein / g feed
array[FEED] of int: minerals_g_per_g = [1, 1, 0, 2, 1];      % g minerals / g feed (0.5 and 0.2 scaled below)
array[FEED] of int: vit_mg_per_g     = [1, 2, 0, 4, 2];      % mg vitamins / g feed (0.5,1,0.2,2,0.8 scaled below)

% Because some coefficients are fractional, scale constraints to keep integers:
% Minerals: 0.5 and 0.2 -> scale minerals by 10
array[FEED] of int: minerals_x10 = [10, 5, 2, 20, 5];        % (g minerals / g feed) * 10
int: req_minerals_x10 = 30 * 10;

% Vitamins: 0.5, 1, 0.2, 2, 0.8 -> scale vitamins by 10
array[FEED] of int: vit_mg_x10 = [5, 10, 2, 20, 8];          % (mg vitamins / g feed) * 10
int: req_vit_mg_x10 = 100 * 10;

% Prices (¥/kg). Cost for x grams is price*(x/1000).
% Multiply objective by 1000 to avoid fractions: minimize sum(price_per_kg * grams)
array[FEED] of float: price_per_kg = [0.2, 0.7, 0.4, 0.3, 0.8];

% Decision variables: grams of each feed per day
% (Upper bound chosen generously; can be increased if needed.)
array[FEED] of var 0..100000: grams;

% Requirements
constraint sum(i in FEED)(protein_g_per_g[i] * grams[i]) >= 700;
constraint sum(i in FEED)(minerals_x10[i]      * grams[i]) >= req_minerals_x10;
constraint sum(i in FEED)(vit_mg_x10[i]        * grams[i]) >= req_vit_mg_x10;

% Objective: minimize total cost (scaled by 1000)
var float: total_cost =
  sum(i in FEED)(price_per_kg[i] * (grams[i] / 1000.0));

solve minimize total_cost;

output [
  "Grams per feed = ", show(grams), "\n",
  "Total cost (Yuan/day) = ", show(total_cost), "\n",
  "Protein supplied (g) = ", show(sum(i in FEED)(protein_g_per_g[i] * grams[i])), "\n",
  "Minerals supplied (g) = ", show(sum(i in FEED)(minerals_x10[i] * grams[i]) / 10.0), "\n",
  "Vitamins supplied (mg) = ", show(sum(i in FEED)(vit_mg_x10[i] * grams[i]) / 10.0), "\n"
];