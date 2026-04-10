% Parameters
int: req_A = 240;     % pieces
int: req_B = 80;      % kg
int: req_C = 120;     % tons

int: capA_A = 4;
int: capA_B = 2;
int: capA_C = 6;
int: costA = 200;

int: capB_A = 7;
int: capB_B = 2;
int: capB_C = 2;
int: costB = 160;

% Variables
var 0..1000: xA; % number of trucks from warehouse A
var 0..1000: xB; % number of trucks from warehouse B

var 0..1000000: total_cost;

% Constraints
constraint capA_A * xA + capB_A * xB >= req_A;
constraint capA_B * xA + capB_B * xB >= req_B;
constraint capA_C * xA + capB_C * xB >= req_C;

constraint total_cost = costA * xA + costB * xB;

% Objective
solve minimize total_cost;