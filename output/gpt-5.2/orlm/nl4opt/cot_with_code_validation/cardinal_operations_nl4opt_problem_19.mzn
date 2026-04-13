% Parameters
int: inspect_avail = 5000;
int: total_avail = 20000;

int: inspect_wash = 30;
int: fix_wash = 90;
int: profit_wash = 250;

int: inspect_freeze = 20;
int: fix_freeze = 125;
int: profit_freeze = 375;

% Variables
var 0..(inspect_avail div inspect_wash): wash;
var 0..(inspect_avail div inspect_freeze): freeze;

% Constraints
constraint inspect_wash * wash + inspect_freeze * freeze <= inspect_avail;
constraint (inspect_wash + fix_wash) * wash + (inspect_freeze + fix_freeze) * freeze <= total_avail;

% Objective
var int: profit = profit_wash * wash + profit_freeze * freeze;
solve maximize profit;