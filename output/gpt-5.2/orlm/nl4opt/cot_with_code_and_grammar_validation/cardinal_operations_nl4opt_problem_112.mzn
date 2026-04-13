% Parameters
int: timeA = 30;
int: timeB = 45;
int: minA = 300;
int: minTotal = 1500;

% Variables
var int: A;
var int: B;
var int: totalTime;

% Constraints
constraint A >= minA;
constraint B >= 0;
constraint A + B >= minTotal;

% At most a third as much A as B: A <= B/3  <=>  3*A <= B
constraint 3 * A <= B;

% Define objective expression
constraint totalTime = timeA * A + timeB * B;

% Objective
solve minimize totalTime;