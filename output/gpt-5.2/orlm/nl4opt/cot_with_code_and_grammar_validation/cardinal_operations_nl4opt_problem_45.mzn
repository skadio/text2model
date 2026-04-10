% Parameters
int: a_max = 46;
int: b_max = 43;
int: c_max = 56;

int: a_pro = 13;
int: b_pro = 4;
int: c_pro = 45;

int: A = 1345;
int: B = 346;
int: C = 1643;

int: profit_max = 10;
int: profit_pro = 15;

% Variables
var 0..(A div a_max): x_max;   % containers of Oil Max
var 0..(A div a_pro): x_pro;   % containers of Oil Max Pro

% Constraints
constraint a_max * x_max + a_pro * x_pro <= A;
constraint b_max * x_max + b_pro * x_pro <= B;
constraint c_max * x_max + c_pro * x_pro <= C;

% Objective
solve maximize profit_max * x_max + profit_pro * x_pro;