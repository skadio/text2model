% Parameters
int: cost_adv = 5;
int: cost_pr  = 2;
int: cost_on  = 3;
int: cost_off = 4;

int: max_adv = 6000;
int: max_pr  = 4000;
int: max_on  = 3000;
int: max_off = 7000;

int: adv_pr_max = 10000;
int: on_off_min = 2000;

int: diff_adv_on_max = 5000;
int: pr_off_min_diff = -1000;

% Variables
var 0..max_adv: adv;
var 0..max_pr: pr;
var 0..max_on: on;
var 0..max_off: off;

var 0..(cost_adv*max_adv + cost_pr*max_pr + cost_on*max_on + cost_off*max_off): total_cost;

% Constraints
constraint adv + pr <= adv_pr_max;
constraint on + off >= on_off_min;

constraint abs(adv - on) <= diff_adv_on_max;

% pr - off >= -1000
constraint pr - off >= pr_off_min_diff;

constraint total_cost = cost_adv*adv + cost_pr*pr + cost_on*on + cost_off*off;

% Objective
solve minimize total_cost;