% Diet / feed mix LP (scaled to integers to avoid float linear limits in Gecode)

int: N = 5;
set of int: FEEDS = 1..N;

% Nutrients per kg feed (from table)
array[FEEDS] of int: protein_g_perkg  = [3, 2, 1, 6, 18];      % g/kg
array[FEEDS] of int: minerals_g_perkg = [1, 0, 0, 2, 0];       % g/kg (scaled below)
array[FEEDS] of int: vitamins_mg_perkg = [5, 10, 2, 20, 8];    % mg/kg (scaled below)
array[FEEDS] of int: price_y_perkg_x10 = [2, 7, 4, 3, 8];      % ¥/kg scaled by 10

% Requirements
int: req_protein_g  = 700;        % g
int: req_minerals_g_x10 = 300;    % 30 g scaled by 10
int: req_vitamins_mg_x10 = 1000;  % 100 mg scaled by 10

% Scale fractional data to integers:
% minerals: multiply by 10 (0.5 -> 5, 0.2 -> 2, 0.5 -> 5)
% vitamins: multiply by 10 (0.5 -> 5, 1.0 -> 10, 0.2 -> 2, 2.0 -> 20, 0.8 -> 8)
array[FEEDS] of int: minerals_g_x10_perkg = [10, 5, 2, 20, 5];
array[FEEDS] of int: vitamins_mg_x10_perkg = [5, 10, 2, 20, 8];

% Decision variables: x[i] = amount of feed i in kg (integer kg for robustness)
% Upper bound large enough: protein min is 1 g/kg so 700 kg suffices; give some slack.
int: UB = 10000;
array[FEEDS] of var 0..UB: x;

var 0..(sum(i in FEEDS)(price_y_perkg_x10[i]*UB)): total_cost_x10;

constraint sum(i in FEEDS)(protein_g_perkg[i] * x[i]) >= req_protein_g;
constraint sum(i in FEEDS)(minerals_g_x10_perkg[i] * x[i]) >= req_minerals_g_x10;
constraint sum(i in FEEDS)(vitamins_mg_x10_perkg[i] * x[i]) >= req_vitamins_mg_x10;

constraint total_cost_x10 = sum(i in FEEDS)(price_y_perkg_x10[i] * x[i]);

solve minimize total_cost_x10;

output [
  "x (kg): ", show([x[i] | i in FEEDS]), "\n",
  "total_cost (scaled x10): ", show(total_cost_x10), "\n",
  "total_cost (Y/kg units): ", show(total_cost_x10), "/10\n"
];