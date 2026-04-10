% Parameters
int: timeA = 30;      % seconds per unit of chemical A
int: timeB = 45;      % seconds per unit of chemical B
int: minA = 300;      % at least 300 units of A
int: minTotal = 1500; % at least 1500 units total (A+B)

% Variables (use a safe explicit upper bound instead of intmax)
var 0..1000000: unitsA;
var 0..1000000: unitsB;

var 0..100000000: totalTime;

% Constraints
constraint unitsA >= minA;
constraint unitsA + unitsB >= minTotal;

% Safety ratio: at most a third as much A as B  =>  A <= B/3  =>  3*A <= B
constraint 3 * unitsA <= unitsB;

% Objective definition
constraint totalTime = timeA * unitsA + timeB * unitsB;

solve minimize totalTime;

output [
  "unitsA=", show(unitsA), "\n",
  "unitsB=", show(unitsB), "\n",
  "totalTime=", show(totalTime), "\n"
];