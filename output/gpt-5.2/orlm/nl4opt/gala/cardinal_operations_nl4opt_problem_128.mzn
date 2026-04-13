include "globals.mzn";

% Data (embedded as per instructions)
int: water_ml = 250000;
int: glass_cap = 500;
int: plastic_cap = 750;

int: min_glass = 20;
int: plastic_ratio = 3;  % plastic >= 3 * glass

% Decision variables: number of bottles
var 0..(water_ml div glass_cap): g;   % glass bottles
var 0..(water_ml div plastic_cap): p; % plastic bottles

% Constraints
constraint g >= min_glass;
constraint p >= plastic_ratio * g;
constraint glass_cap * g + plastic_cap * p <= water_ml;

% Objective: maximize total number of bottles
var 0..(water_ml div min(glass_cap, plastic_cap)): total = g + p;
solve maximize total;

output [
  "Glass bottles (500ml) = ", show(g), "\n",
  "Plastic bottles (750ml) = ", show(p), "\n",
  "Total bottles = ", show(total), "\n",
  "Water used (ml) = ", show(glass_cap*g + plastic_cap*p), " / ", show(water_ml), "\n"
];