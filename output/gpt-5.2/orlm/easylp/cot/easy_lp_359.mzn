% Parameters (with values embedded)
int: c1 = 50;
int: c2 = 60;
int: c3 = 30;
int: c4 = 40;

int: x1_min = 0;    int: x1_max = 3000;
int: x2_min = 0;    int: x2_max = 2500;
int: x3_min = 0;    int: x3_max = 1500;
int: x4_min = 0;    int: x4_max = 1200;

int: cap12 = 5000;
int: cap34 = 2000;
int: diff12_min = 1000;
int: diff34_max = 500;

% Variables
var x1_min..x1_max: x1;
var x2_min..x2_max: x2;
var x3_min..x3_max: x3;
var x4_min..x4_max: x4;

var 0..(c1*x1_max + c2*x2_max + c3*x3_max + c4*x4_max): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint x1 - x2 >= diff12_min;

constraint x3 - x4 <= diff34_max;
constraint x4 - x3 <= diff34_max; % enforces |x3 - x4| <= 500

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;