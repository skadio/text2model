% Parameters
int: costX = 50;
int: costY = 70;
int: demandMin = 5000;
int: emitX = 10;
int: emitY = 15;
int: emitMax = 80000;

% Variables
var 0..demandMin: X;
var 0..demandMin: Y;

% Constraints
constraint X + Y >= demandMin;
constraint emitX * X + emitY * Y <= emitMax;

% Objective
solve minimize costX * X + costY * Y;