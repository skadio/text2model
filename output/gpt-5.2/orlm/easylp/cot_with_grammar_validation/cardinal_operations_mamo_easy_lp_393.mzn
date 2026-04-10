% Parameters
int: costT = 500;
int: costP = 300;
int: costS = 200;
int: costR = 100;

int: maxTP = 50;
int: maxSR = 30;

int: minT = 15;
int: minP = 10;
int: minS = 5;
int: minR = 2;

% Variables
var minT..maxTP: T;
var minP..maxTP: P;
var minS..maxSR: S;
var minR..maxSR: R;

var int: total_cost;

% Constraints
constraint T + P <= maxTP;
constraint S + R <= maxSR;

constraint total_cost = costT*T + costP*P + costS*S + costR*R;

% Objective
solve minimize total_cost;