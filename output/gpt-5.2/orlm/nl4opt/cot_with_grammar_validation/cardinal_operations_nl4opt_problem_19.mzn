% Parameters
int: insp_wash = 30;
int: fix_wash = 90;
int: insp_freeze = 20;
int: fix_freeze = 125;

int: insp_avail = 5000;
int: time_avail = 20000;

int: profit_wash = 250;
int: profit_freeze = 375;

% Variables
var 0..(insp_avail div insp_wash): wash;
var 0..(insp_avail div insp_freeze): freeze;

% Constraints
constraint insp_wash * wash + insp_freeze * freeze <= insp_avail;
constraint fix_wash * wash + fix_freeze * freeze <= time_avail;

% Objective
solve maximize profit_wash * wash + profit_freeze * freeze;