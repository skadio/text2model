% Parameters (with values embedded)
int: intensityX = 8;
int: intensityY = 12;
int: maxTotalHours = 20;

int: effX = 5;
int: effY = 3;
int: minEffectiveness = 15;

% Variables
var 0..maxTotalHours: hoursX;
var 0..maxTotalHours: hoursY;
var 0..(intensityX*maxTotalHours + intensityY*maxTotalHours): totalIntensity;

% Constraints
constraint hoursX + hoursY <= maxTotalHours;
constraint effX * hoursX + effY * hoursY >= minEffectiveness;

constraint totalIntensity = intensityX * hoursX + intensityY * hoursY;

% Objective
solve minimize totalIntensity;