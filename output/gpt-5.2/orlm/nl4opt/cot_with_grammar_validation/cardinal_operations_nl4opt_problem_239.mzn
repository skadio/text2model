% Parameters
float: pain_per_pill1 = 0.2;
float: anx_per_pill1  = 0.3;
float: dis_per_pill1  = 0.3;

float: pain_per_pill2 = 0.6;
float: anx_per_pill2  = 0.2;
float: dis_per_pill2  = 0.1;

float: max_pain = 6.0;
float: min_anx  = 3.0;

% Variables
var 0..100: x1; % number of Pill 1
var 0..100: x2; % number of Pill 2

var float: total_pain;
var float: total_anx;
var float: total_discharge;

% Constraints
constraint total_pain = pain_per_pill1 * int2float(x1) + pain_per_pill2 * int2float(x2);
constraint total_anx  = anx_per_pill1  * int2float(x1) + anx_per_pill2  * int2float(x2);
constraint total_discharge = dis_per_pill1 * int2float(x1) + dis_per_pill2 * int2float(x2);

constraint total_pain <= max_pain;
constraint total_anx >= min_anx;

% Objective
solve minimize total_discharge;