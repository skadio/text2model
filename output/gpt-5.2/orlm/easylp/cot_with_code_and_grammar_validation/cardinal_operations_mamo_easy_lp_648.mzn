% Parameters
int: c1 = 5000;
int: c2 = 3000;
int: c3 = 4000;
int: c4 = 2000;

int: total_max = 10000;

int: x1_min = 0;    int: x1_max = 3000;
int: x2_min = 0;    int: x2_max = 2500;
int: x3_min = 0;    int: x3_max = 1500;
int: x4_min = 0;    int: x4_max = 300;

% Variables
var x1_min..x1_max: x1;
var x2_min..x2_max: x2;
var x3_min..x3_max: x3;
var x4_min..x4_max: x4;

var 0..(c1*x1_max + c2*x2_max + c3*x3_max + c4*x4_max): total_cost;

% Constraints
constraint x1 + x2 + x3 + x4 <= total_max;

% 5*x1 >= 2000 + 3.5*x2  ==> 10*x1 >= 4000 + 7*x2
constraint 10*x1 >= 4000 + 7*x2;

% 4.7*x4 <= x3 + 3500  ==> 47*x4 <= 10*x3 + 35000
constraint 47*x4 <= 10*x3 + 35000;

% x2 + 3.5*x3 + x4 - 2.5*x1 >= 1000  ==> 2*x2 + 7*x3 + 2*x4 - 5*x1 >= 2000
constraint 2*x2 + 7*x3 + 2*x4 - 5*x1 >= 2000;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;