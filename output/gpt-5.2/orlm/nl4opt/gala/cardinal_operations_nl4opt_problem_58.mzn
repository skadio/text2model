% Calcium vs Vitamin D pills (sequential effectiveness time minimization)

% Embedded data (from problem statement)
int: calcium_time = 5;     % minutes per calcium pill
int: vitamin_time = 6;     % minutes per vitamin D pill
int: min_total_pills = 130;
int: min_vitamin_pills = 40;

% Decision variables
var 0..10000: calcium;     % number of calcium pills
var 0..10000: vitaminD;    % number of vitamin D pills

% Constraints
constraint calcium + vitaminD >= min_total_pills;
constraint vitaminD >= min_vitamin_pills;
constraint calcium > vitaminD;  % more calcium than vitamin D

% Objective: minimize total time for pills to be effective
var 0..1000000: total_time = calcium_time * calcium + vitamin_time * vitaminD;

solve minimize total_time;

output [
  "calcium = ", show(calcium), "\n",
  "vitaminD = ", show(vitaminD), "\n",
  "total_pills = ", show(calcium + vitaminD), "\n",
  "total_time_minutes = ", show(total_time), "\n"
];