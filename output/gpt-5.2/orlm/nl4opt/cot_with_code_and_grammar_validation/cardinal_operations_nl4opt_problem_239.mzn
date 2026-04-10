% Parameters
float: pain_pill1 = 0.2;
float: anxiety_pill1 = 0.3;
float: discharge_pill1 = 0.3;

float: pain_pill2 = 0.6;
float: anxiety_pill2 = 0.2;
float: discharge_pill2 = 0.1;

float: pain_max = 6.0;
float: anxiety_min = 3.0;

% Variables
var 0..100: x1; % number of pill 1
var 0..100: x2; % number of pill 2

% Constraints
constraint pain_pill1 * x1 + pain_pill2 * x2 <= pain_max;
constraint anxiety_pill1 * x1 + anxiety_pill2 * x2 >= anxiety_min;

% Objective
solve minimize discharge_pill1 * x1 + discharge_pill2 * x2;