% Parameters
int: total_antibiotics = 35000;
int: abx_first = 30;
int: abx_second = 65;
int: gel_first = 20;   % mg
int: gel_second = 60;  % mg
int: min_second = 40;

% Variables
var 0..(total_antibiotics div abx_first): first_dose;
var min_second..(total_antibiotics div abx_second): second_dose;
var 0..(gel_first * (total_antibiotics div abx_first) + gel_second * (total_antibiotics div abx_second)): total_gel;

% Constraints
constraint abx_first * first_dose + abx_second * second_dose <= total_antibiotics;
constraint first_dose > second_dose;

constraint total_gel = gel_first * first_dose + gel_second * second_dose;

% Objective
solve minimize total_gel;