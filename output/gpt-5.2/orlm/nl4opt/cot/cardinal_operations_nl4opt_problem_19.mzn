% Parameters (with values embedded)
int: inspect_wm = 30;
int: fix_wm = 90;
int: inspect_fr = 20;
int: fix_fr = 125;

int: inspect_total = 5000;
int: fix_total = 20000;

int: profit_wm = 250;
int: profit_fr = 375;

% Variables
var 0..(inspect_total div inspect_wm): wm;  % number of washing machines
var 0..(inspect_total div inspect_fr): fr;  % number of freezers

% Constraints
constraint inspect_wm * wm + inspect_fr * fr <= inspect_total;
constraint fix_wm * wm + fix_fr * fr <= fix_total;

% Objective
var int: earnings = profit_wm * wm + profit_fr * fr;
solve maximize earnings;