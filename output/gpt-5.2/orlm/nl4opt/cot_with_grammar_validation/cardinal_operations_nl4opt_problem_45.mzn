% Parameters
int: A_avail = 1345;
int: B_avail = 346;
int: C_avail = 1643;

int: A_max = 46;
int: B_max = 43;
int: C_max = 56;

int: A_pro = 13;
int: B_pro = 4;
int: C_pro = 45;

int: profit_max = 10;
int: profit_pro = 15;

% Variables
var 0..min(A_avail div A_max, min(B_avail div B_max, C_avail div C_max)): x_max;
var 0..min(A_avail div A_pro, min(B_avail div B_pro, C_avail div C_pro)): x_pro;

var 0..(profit_max*(A_avail div A_max) + profit_pro*(A_avail div A_pro)): total_profit;

% Constraints
constraint A_max * x_max + A_pro * x_pro <= A_avail;
constraint B_max * x_max + B_pro * x_pro <= B_avail;
constraint C_max * x_max + C_pro * x_pro <= C_avail;

constraint total_profit = profit_max * x_max + profit_pro * x_pro;

% Objective
solve maximize total_profit;