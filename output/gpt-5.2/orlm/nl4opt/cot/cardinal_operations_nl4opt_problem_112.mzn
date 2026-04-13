% Parameters (with values embedded)
int: timeA = 30;          % seconds per unit of chemical A
int: timeB = 45;          % seconds per unit of chemical B
int: minA  = 300;         % at least 300 units of A
int: minTotal = 1500;     % at least 1500 total units
% Safety constraint: A <= (1/3) * B  ->  3*A <= B

% Variables
var 0..100000: A;
var 0..100000: B;

% Constraints
constraint A >= minA;
constraint A + B >= minTotal;
constraint 3 * A <= B;

% Objective
var int: totalTime = timeA * A + timeB * B;
solve minimize totalTime;