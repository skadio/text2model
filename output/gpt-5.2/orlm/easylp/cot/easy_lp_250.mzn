% Parameters (with values embedded)
int: timeX = 1;
int: timeY = 2;
int: timeZ = 3;

% Variables
var 0..10: X;
var 0..10: Y;
var 0..10: Z;

% Constraints
constraint 2 * X * timeX + Y * timeY <= 6;     % twice as many X plus Y time <= 6
constraint X * timeX + Z * timeZ <= 5;         % X and Z time <= 5
constraint Y * timeY + Z * timeZ >= 7;         % Y and Z time >= 7

% Objective
var 0..100: totalHours = X * timeX + Y * timeY + Z * timeZ;
solve minimize totalHours;