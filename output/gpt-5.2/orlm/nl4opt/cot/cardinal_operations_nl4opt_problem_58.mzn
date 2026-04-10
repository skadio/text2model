% Parameters (with values embedded)
int: timeCalcium = 5;          % minutes per calcium pill
int: timeVitaminD = 6;         % minutes per vitamin D pill
int: minTotalPills = 130;      % at least 130 pills total
int: minVitaminD = 40;         % at least 40 vitamin D pills

% Variables
var 0..10000: calcium;
var 0..10000: vitaminD;

% Constraints
constraint calcium + vitaminD >= minTotalPills;
constraint vitaminD >= minVitaminD;
constraint calcium > vitaminD;

% Objective
solve minimize timeCalcium * calcium + timeVitaminD * vitaminD;