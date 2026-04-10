% Parameters
int: c1 = 4;
int: c2 = 2;
int: c3 = 3;
int: c4 = 5;

int: D21 = 100;   % |0.5*x2 - x1| <= 100
int: K13 = 200;   % x1 >= 0.7*x3 + 200
int: D42 = 150;   % |x4 - 0.6*x2| <= 150
int: D31 = 300;   % |0.8*x3 - x1| <= 300
int: K42 = 50;    % x4 >= x2 + 50

% NOTE: The problem statement mentions "specific bounds on resource allocation"
% but does not provide numeric bounds. We therefore use a safe derived upper bound
% sufficient for optimization given the constraints (x1 >= 200 forces objective > 0).
int: UB = 10000;

% Variables
var 0..UB: x1;
var 0..UB: x2;
var 0..UB: x3;
var 0..UB: x4;

% Constraints
% |0.5*x2 - x1| <= 100  ->  |x2 - 2*x1| <= 200
constraint x2 - 2*x1 <= 2*D21;
constraint 2*x1 - x2 <= 2*D21;

% x1 >= 0.7*x3 + 200  ->  10*x1 >= 7*x3 + 2000
constraint 10*x1 >= 7*x3 + 10*K13;

% |x4 - 0.6*x2| <= 150  ->  |5*x4 - 3*x2| <= 750
constraint 5*x4 - 3*x2 <= 5*D42;
constraint 3*x2 - 5*x4 <= 5*D42;

% |0.8*x3 - x1| <= 300  ->  |4*x3 - 5*x1| <= 1500
constraint 4*x3 - 5*x1 <= 5*D31;
constraint 5*x1 - 4*x3 <= 5*D31;

% x4 >= x2 + 50
constraint x4 >= x2 + K42;

% Objective
solve minimize c1*x1 + c2*x2 + c3*x3 + c4*x4;