% Parameters
int: timeA = 30;
int: timeB = 45;
int: minA = 300;
int: minTotal = 1500;

% Variables
var minA..minTotal: A;
var 0..minTotal: B;
var 0..(timeA*minTotal + timeB*minTotal): totalTime;

% Constraints
constraint A + B >= minTotal;
constraint 3 * A <= B; % A <= (1/3) * B
constraint totalTime = timeA * A + timeB * B;

% Objective
solve minimize totalTime;