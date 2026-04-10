% Parameters
int: honey_ml = 20000;
int: glass_capacity_ml = 250;
int: plastic_capacity_ml = 300;
int: min_glass = 20;
int: plastic_at_least_factor = 2;

% Variables
var 0..(honey_ml div glass_capacity_ml): glass_jars;
var 0..(honey_ml div plastic_capacity_ml): plastic_jars;

% Constraints
constraint glass_jars >= min_glass;
constraint plastic_jars >= plastic_at_least_factor * glass_jars;
constraint glass_capacity_ml * glass_jars + plastic_capacity_ml * plastic_jars <= honey_ml;

% Objective
solve maximize glass_jars + plastic_jars;