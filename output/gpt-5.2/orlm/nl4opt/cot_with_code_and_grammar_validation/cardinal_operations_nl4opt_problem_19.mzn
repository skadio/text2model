% Parameters
int: insp_wash = 30;
int: fix_wash  = 90;
int: insp_freeze = 20;
int: fix_freeze  = 125;

int: insp_cap = 5000;
int: total_cap = 20000;

int: profit_wash = 250;
int: profit_freeze = 375;

% Variables
var 0..min(insp_cap div insp_wash, total_cap div (insp_wash + fix_wash)): wash;
var 0..min(insp_cap div insp_freeze, total_cap div (insp_freeze + fix_freeze)): freeze;

var 0..(profit_wash * (insp_cap div insp_wash) + profit_freeze * (insp_cap div insp_freeze)): profit;

% Constraints
constraint insp_wash * wash + insp_freeze * freeze <= insp_cap;
constraint (insp_wash + fix_wash) * wash + (insp_freeze + fix_freeze) * freeze <= total_cap;

constraint profit = profit_wash * wash + profit_freeze * freeze;

% Objective
solve maximize profit;