% Parameters
int: U1 = 100;
int: U2 = 80;
int: U3 = 60;
int: U4 = 50;

float: c1 = 0.5;
float: c2 = 0.2;
float: c3 = 0.3;
float: c4 = 0.4;

% Variables
var 0..U1: X1;
var 0..U2: X2;
var 0..U3: X3;
var 0..U4: X4;

% Objective variable (scaled to avoid float objective; costs are tenths)
var 0..(10*U1*c1 + 10*U2*c2 + 10*U3*c3 + 10*U4*c4): cost10;

% Constraints
constraint X1 + X2 <= 100;
constraint X2 + X3 >= 50;
constraint X3 - X4 <= 30;

constraint 10*X1 + 15*X2 - 5*X3 - 20*X4 >= 150;

% Link scaled objective: cost10 = 10 * total_cost
constraint cost10 = 5*X1 + 2*X2 + 3*X3 + 4*X4;

% Objective
solve minimize cost10;