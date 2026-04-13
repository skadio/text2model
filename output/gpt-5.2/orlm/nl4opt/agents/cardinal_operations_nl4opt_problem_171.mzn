% Parameters
int: glass_capacity_ml = 250;        % ml per glass jar
int: plastic_capacity_ml = 300;      % ml per plastic jar
int: total_honey_ml = 20000;         % total available honey in ml
int: min_glass_jars = 20;            % minimum number of glass jars to fill
int: plastic_to_glass_ratio = 2;     % plastic jars must be at least this multiple of glass jars

% Upper bounds derived from capacities and total honey (integer, safe bounds)
int: max_glass_jars = total_honey_ml div glass_capacity_ml;
int: max_plastic_jars = total_honey_ml div plastic_capacity_ml;

% Variables
var 0..max_glass_jars: glass_jars;     % number of glass jars to fill
var 0..max_plastic_jars: plastic_jars; % number of plastic jars to fill

% Constraints
% Honey usage constraint: total honey used by all filled jars cannot exceed available honey
constraint
  glass_capacity_ml * glass_jars + plastic_capacity_ml * plastic_jars <= total_honey_ml;

% Minimum glass jars constraint: must fill at least the required number of glass jars
constraint
  glass_jars >= min_glass_jars;

% Ratio constraint: at least twice as many plastic jars as glass jars
constraint
  plastic_jars >= plastic_to_glass_ratio * glass_jars;

% Objective
solve maximize (glass_jars + plastic_jars);