% Parameters
int: glass_capacity_ml = 250;          % ml per glass jar
int: plastic_capacity_ml = 300;        % ml per plastic jar
int: total_honey_ml = 20000;           % total honey available (ml)
int: min_glass_jars = 20;              % at least this many glass jars
int: plastic_to_glass_ratio = 2;       % plastic jars must be at least this multiple of glass jars

% Variables
var min_glass_jars..(total_honey_ml div glass_capacity_ml): glass_jars; % number of glass jars filled
var 0..(total_honey_ml div plastic_capacity_ml): plastic_jars;          % number of plastic jars filled
var 0..(total_honey_ml div min(glass_capacity_ml, plastic_capacity_ml)): total_jars; % total jars filled

% Constraints
% Total jars definition (linking constraint)
constraint total_jars = glass_jars + plastic_jars;

% Honey capacity limit: do not exceed available honey
constraint
  glass_capacity_ml * glass_jars + plastic_capacity_ml * plastic_jars <= total_honey_ml;

% Minimum glass jars requirement (redundant with var lower bound, kept for clarity)
constraint
  glass_jars >= min_glass_jars;

% Ratio requirement: at least plastic_to_glass_ratio plastic jars per glass jar
constraint
  plastic_jars >= plastic_to_glass_ratio * glass_jars;

% Objective
solve maximize total_jars;