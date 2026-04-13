% Parameters
int: glass_capacity_ml = 500;        % ml per glass bottle
int: plastic_capacity_ml = 750;      % ml per plastic bottle
int: total_water_ml = 250000;        % total available water (ml)
int: min_glass = 20;                 % minimum required number of glass bottles
int: plastic_to_glass_ratio = 3;     % plastic bottles must be at least this times glass bottles

% Variables
% Upper bounds derived from total water to keep the search finite and efficient
var 0..(total_water_ml div glass_capacity_ml): glass_bottles;     % number of glass bottles produced
var 0..(total_water_ml div plastic_capacity_ml): plastic_bottles; % number of plastic bottles produced

% Constraints
% Minimum production and non-negativity
constraint glass_bottles >= min_glass;

% Total water used cannot exceed available water
constraint glass_capacity_ml * glass_bottles
         + plastic_capacity_ml * plastic_bottles
         <= total_water_ml;

% Plastic bottles must be at least 3 times the number of glass bottles
constraint plastic_bottles >= plastic_to_glass_ratio * glass_bottles;

% Objective
solve maximize glass_bottles + plastic_bottles;