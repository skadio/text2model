% Parameters
int: req_A = 150;
int: req_D = 300;
int: max_E = 400;

int: A_A = 8;
int: A_D = 6;
int: A_E = 10;
int: A_K = 4;

int: B_A = 15;
int: B_D = 2;
int: B_E = 20;
int: B_K = 12;

% Upper bounds derived from constraints to keep variables bounded
int: UB_x = max_E div A_E; % from 10*x <= 400
int: UB_y = max_E div B_E; % from 20*y <= 400

% Variables
var 0..UB_x: x; % cups of drink A
var 0..UB_y: y; % cups of drink B

var int: total_K;

% Constraints
constraint A_A * x + B_A * y >= req_A;
constraint A_D * x + B_D * y >= req_D;
constraint A_E * x + B_E * y <= max_E;

constraint total_K = A_K * x + B_K * y;

% Objective
solve minimize total_K;