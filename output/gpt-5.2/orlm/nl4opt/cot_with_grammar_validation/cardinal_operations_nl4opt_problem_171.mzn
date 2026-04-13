% Parameters
int: glass_capacity = 250;        % ml per glass jar
int: plastic_capacity = 300;      % ml per plastic jar
int: total_honey = 20000;         % ml available
int: min_glass = 20;              % at least this many glass jars
int: plastic_to_glass_ratio = 2;  % plastic jars >= ratio * glass jars

% Variables
var min_glass..(total_honey div glass_capacity): g;   % number of glass jars
var 0..(total_honey div plastic_capacity): p;         % number of plastic jars

% Constraints
constraint glass_capacity * g + plastic_capacity * p <= total_honey;
constraint p >= plastic_to_glass_ratio * g;

% Objective
solve maximize (g + p);