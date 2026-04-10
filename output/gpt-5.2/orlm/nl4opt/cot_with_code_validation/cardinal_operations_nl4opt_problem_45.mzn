% Parameters
int: a_max = 46;
int: b_max = 43;
int: c_max = 56;

int: a_pro = 13;
int: b_pro = 4;
int: c_pro = 45;

int: A_avail = 1345;
int: B_avail = 346;
int: C_avail = 1643;

int: profit_max = 10;
int: profit_pro = 15;

% Variables
var 0..(A_avail div a_max): x_max;     % containers of Oil Max
var 0..(A_avail div a_pro): x_pro;     % containers of Oil Max Pro

var 0..(profit_max*(A_avail div a_max) + profit_pro*(A_avail div a_pro)): total_profit;

% Constraints
constraint a_max * x_max + a_pro * x_pro <= A_avail;
constraint b_max * x_max + b_pro * x_pro <= B_avail;
constraint c_max * x_max + c_pro * x_pro <= C_avail;

constraint total_profit = profit_max * x_max + profit_pro * x_pro;

% Objective
solve maximize total_profit;