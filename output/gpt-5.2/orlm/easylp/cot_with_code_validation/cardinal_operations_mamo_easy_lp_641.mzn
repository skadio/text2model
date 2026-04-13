% Parameters
int: c1 = 100;
int: c2 = 150;
int: c3 = 80;
int: c4 = 50;

int: rhs1 = 5000;
int: rhs2 = 2000;
int: rhs3 = 4000;
int: rhs4 = 3000;

% scale to remove halves: multiply all constraints by 2
int: scale = 2;

% Variables
var 0..100000: x1;
var 0..100000: x2;
var 0..100000: x3;
var 0..100000: x4;

var 0..1000000000: total_cost;

% Constraints
constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% 3*x1 + 2*x2 - x3 <= 5000
constraint 3*x1 + 2*x2 - x3 <= rhs1;

% -x1 + 4*x2 + x4 >= 2000
constraint -x1 + 4*x2 + x4 >= rhs2;

% -x1 - x2 + 5*x3 - x4 == 4000
constraint -x1 - x2 + 5*x3 - x4 = rhs3;

% 6*x2 + 7.5*x3 - 8.5*x4 - x1 <= 3000
% scaled by 2: 12*x2 + 15*x3 - 17*x4 - 2*x1 <= 6000
constraint 12*x2 + 15*x3 - 17*x4 - 2*x1 <= scale*rhs4;

% Objective
solve minimize total_cost;