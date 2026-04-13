include "globals.mzn";

% Data (embedded as requested)
int: honey_ml = 20000;
int: glass_cap = 250;
int: plastic_cap = 300;

int: min_glass = 20;          % at least 20 glass jars
int: plastic_ratio = 2;       % plastic >= 2 * glass

% Decision variables
var 0..honey_ml div glass_cap: glass;     % number of glass jars
var 0..honey_ml div plastic_cap: plastic; % number of plastic jars

% Constraints
constraint glass >= min_glass;
constraint plastic >= plastic_ratio * glass;

% Total honey used cannot exceed available honey
constraint glass * glass_cap + plastic * plastic_cap <= honey_ml;

% Objective: maximize total number of jars filled
var 0..(honey_ml div min(glass_cap, plastic_cap)): total_jars;
constraint total_jars = glass + plastic;

solve maximize total_jars;

output [
  "glass = ", show(glass), "\n",
  "plastic = ", show(plastic), "\n",
  "total_jars = ", show(total_jars), "\n",
  "used_honey_ml = ", show(glass * glass_cap + plastic * plastic_cap), "\n"
];