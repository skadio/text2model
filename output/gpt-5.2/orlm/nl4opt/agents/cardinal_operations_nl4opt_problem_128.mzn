% Parameters
int: glass_capacity_ml = 500;          % ml per glass bottle
int: plastic_capacity_ml = 750;        % ml per plastic bottle
int: total_water_ml = 250000;          % total available water (ml)
int: plastic_to_glass_ratio = 3;       % plastic bottles >= ratio * glass bottles
int: min_glass_bottles = 20;           % minimum number of glass bottles

% Derived bounds for variable declarations (to keep variables bounded)
int: max_glass_bottles = total_water_ml div glass_capacity_ml;
int: max_plastic_bottles = total_water_ml div plastic_capacity_ml;

% Variables
var 0..max_glass_bottles: num_glass;       % number of glass bottles produced
var 0..max_plastic_bottles: num_plastic;   % number of plastic bottles produced
var 0..(max_glass_bottles + max_plastic_bottles): total_bottles; % total bottles produced

% Constraints

% Link total_bottles to the sum of produced bottles
constraint
  total_bottles = num_glass + num_plastic;

% Water availability constraint (do not exceed total water)
constraint
  glass_capacity_ml * num_glass + plastic_capacity_ml * num_plastic <= total_water_ml;

% Demand preference: plastic bottles must be at least a multiple of glass bottles
constraint
  num_plastic >= plastic_to_glass_ratio * num_glass;

% Minimum production requirement for glass bottles
constraint
  num_glass >= min_glass_bottles;

% Objective
solve maximize total_bottles;