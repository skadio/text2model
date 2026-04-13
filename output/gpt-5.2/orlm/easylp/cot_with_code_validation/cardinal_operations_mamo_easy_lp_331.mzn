% Parameters
int: cost_adv = 5;
int: cost_pr = 2;
int: cost_online = 3;
int: cost_offline = 4;

int: ub_adv = 6000;
int: ub_pr = 4000;
int: ub_online = 3000;
int: ub_offline = 7000;

int: max_adv_pr = 10000;
int: min_online_offline = 2000;

int: max_diff_adv_online = 5000;
int: min_diff_pr_offline = -1000;

% Variables
var 0..ub_adv: adv;
var 0..ub_pr: pr;
var 0..ub_online: online;
var 0..ub_offline: offline;

var 0..(cost_adv*ub_adv + cost_pr*ub_pr + cost_online*ub_online + cost_offline*ub_offline): total_cost;

% Constraints
constraint adv + pr <= max_adv_pr;
constraint online + offline >= min_online_offline;

constraint adv - online <= max_diff_adv_online;
constraint online - adv <= max_diff_adv_online;

constraint pr - offline >= min_diff_pr_offline;

constraint total_cost = cost_adv*adv + cost_pr*pr + cost_online*online + cost_offline*offline;

% Objective
solve minimize total_cost;