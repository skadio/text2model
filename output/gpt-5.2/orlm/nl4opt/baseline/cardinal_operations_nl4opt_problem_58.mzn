% Calcium and Vitamin D pills optimization (all data embedded)

int: time_calcium = 5;   % minutes per calcium pill
int: time_vitD    = 6;   % minutes per vitamin D pill

int: min_total_pills = 130;
int: min_vitD_pills  = 40;

var int: calcium;
var int: vitD;

constraint calcium >= 0;
constraint vitD >= 0;

constraint calcium + vitD >= min_total_pills;
constraint vitD >= min_vitD_pills;
constraint calcium > vitD;  % more calcium than vitamin D

var int: total_time = time_calcium * calcium + time_vitD * vitD;

solve minimize total_time;

output [
  "calcium_pills = ", show(calcium), "\n",
  "vitaminD_pills = ", show(vitD), "\n",
  "total_time_minutes = ", show(total_time), "\n"
];