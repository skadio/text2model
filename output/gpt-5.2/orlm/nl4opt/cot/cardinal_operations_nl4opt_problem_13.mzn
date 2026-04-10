% Parameters (with values embedded)
float: b1_pancreas = 0.3;
float: b1_skin     = 0.2;
float: b1_tumor    = 0.6;

float: b2_pancreas = 0.2;
float: b2_skin     = 0.1;
float: b2_tumor    = 0.4;

float: skin_max  = 4.0;
float: tumor_min = 3.0;

% Variables
var 0.0..100.0: x1; % minutes of Beam 1
var 0.0..100.0: x2; % minutes of Beam 2

% Constraints
constraint b1_skin * x1 + b2_skin * x2 <= skin_max;
constraint b1_tumor * x1 + b2_tumor * x2 >= tumor_min;

% Objective
solve minimize b1_pancreas * x1 + b2_pancreas * x2;