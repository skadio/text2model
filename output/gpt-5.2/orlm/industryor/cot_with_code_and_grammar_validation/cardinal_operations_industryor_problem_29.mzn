% Feed mix LP (scaled to integers to avoid float-linear limits in Gecode)

int: N = 5;
set of int: FEED = 1..N;

% Scale all amounts to avoid floats:
% Let x[i] be grams of feed i.
% Protein/minerals given as g per kg -> multiply by 1000 (g/kg) and keep grams of nutrient.
% Vitamins given as mg per kg -> multiply by 1000 (mg/kg) and keep mg of nutrient.
% Price given as ¥/kg -> minimize total cost in 0.1¥ units: price_tenth_yen_per_kg.

array[FEED] of int: protein_g_per_kg   = [3000, 2000, 1000, 6000, 18000];
array[FEED] of int: minerals_g_per_kg  = [1000,  500,  200, 2000,   500];
array[FEED] of int: vitamins_mg_per_kg = [ 500, 1000,  200, 2000,   800];

% Prices (¥/kg): [0.2, 0.7, 0.4, 0.3, 0.8] => in 0.1¥ units: [2,7,4,3,8]
array[FEED] of int: price_tenth_yen_per_kg = [2, 7, 4, 3, 8];

int: req_protein_g  = 700;
int: req_minerals_g = 30;
int: req_vitamins_mg = 100;

% Decision variables: grams of each feed (integer)
array[FEED] of var int: x_g;
constraint forall(i in FEED)(x_g[i] >= 0);

% Nutrient constraints:
% nutrient_from_i = (nutrient_per_kg * grams)/1000
constraint sum(i in FEED)(protein_g_per_kg[i] * x_g[i])  >= req_protein_g  * 1000;
constraint sum(i in FEED)(minerals_g_per_kg[i] * x_g[i]) >= req_minerals_g * 1000;
constraint sum(i in FEED)(vitamins_mg_per_kg[i] * x_g[i]) >= req_vitamins_mg * 1000;

% Objective (total cost in 0.1¥):
% cost = sum( price(0.1¥/kg) * grams / 1000 )
% Minimizing numerator is equivalent (since /1000 is constant).
var int: total_cost_tenth_yen_times1000 = sum(i in FEED)(price_tenth_yen_per_kg[i] * x_g[i]);

solve minimize total_cost_tenth_yen_times1000;

output [
  "x_g (grams) = ", show(x_g), "\n",
  "total_cost (tenth_yen*1000) = ", show(total_cost_tenth_yen_times1000), "\n"
];