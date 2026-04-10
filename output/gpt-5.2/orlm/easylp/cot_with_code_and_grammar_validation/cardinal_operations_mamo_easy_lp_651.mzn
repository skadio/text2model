% Parameters
int: c1 = 500;
int: c2 = 300;
int: c3 = 200;
int: c4 = 100;

int: b12 = 50;
int: b34 = 70;

% Variables
var 0..b12: x1;
var 0..b12: x2;
var 0..b34: x3;
var 0..b34: x4;

% Constraints
constraint x1 + x2 <= b12;
constraint x3 + x4 <= b34;

% ROI: 0.5*x1 - 0.25*x2 + 0.15*x3 + 1.0*x4 >= 20
% Multiply by 20 to avoid fractions: 10*x1 - 5*x2 + 3*x3 + 20*x4 >= 400
constraint 10*x1 - 5*x2 + 3*x3 + 20*x4 >= 400;

% Diversification:
% 2.5*x2 + 0.75*x3 - x1 - x4 <= 30
% Multiply by 4: 10*x2 + 3*x3 - 4*x1 - 4*x4 <= 120
constraint 10*x2 + 3*x3 - 4*x1 - 4*x4 <= 120;

% Objective
solve minimize c1*x1 + c2*x2 + c3*x3 + c4*x4;