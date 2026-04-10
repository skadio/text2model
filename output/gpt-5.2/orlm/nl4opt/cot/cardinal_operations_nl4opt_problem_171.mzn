% Parameters (with values embedded)
int: honey_ml = 20000;
int: glass_capacity = 250;
int: plastic_capacity = 300;
int: min_glass = 20;

% Variables
var 0..(honey_ml div glass_capacity): glass_jars;
var 0..(honey_ml div plastic_capacity): plastic_jars;
var 0..(honey_ml div min(glass_capacity, plastic_capacity)): total_jars;

% Constraints
constraint glass_jars >= min_glass;
constraint plastic_jars >= 2 * glass_jars;

constraint glass_capacity * glass_jars + plastic_capacity * plastic_jars <= honey_ml;

constraint total_jars = glass_jars + plastic_jars;

% Objective
solve maximize total_jars;