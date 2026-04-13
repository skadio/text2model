% Parameters
int: honey_ml = 20000;
int: glass_capacity = 250;
int: plastic_capacity = 300;
int: min_glass = 20;

% Variables
var 0..(honey_ml div glass_capacity): glass;
var 0..(honey_ml div plastic_capacity): plastic;

% Constraints
constraint glass >= min_glass;
constraint plastic >= 2 * glass;
constraint glass_capacity * glass + plastic_capacity * plastic <= honey_ml;

% Objective
solve maximize glass + plastic;