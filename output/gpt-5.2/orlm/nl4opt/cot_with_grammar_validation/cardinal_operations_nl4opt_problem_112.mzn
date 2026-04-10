% Parameters
int: timeA = 30;
int: timeB = 45;
int: minA = 300;
int: minTotal = 1500;

% Variables
var int: A;
var int: B;

% Constraints
constraint A >= 0;
constraint B >= 0;

constraint A >= minA;
constraint A + B >= minTotal;

% At most a third as much A as B: A <= B/3  <=>  3*A <= B
constraint 3 * A <= B;

% Objective
solve minimize timeA * A + timeB * B;