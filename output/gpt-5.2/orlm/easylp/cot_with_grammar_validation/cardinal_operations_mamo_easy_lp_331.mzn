% Parameters
int: cost_advertising = 5;
int: cost_pr = 2;
int: cost_online = 3;
int: cost_offline = 4;

int: max_advertising = 6000;
int: max_pr = 4000;
int: max_online = 3000;
int: max_offline = 7000;

int: max_adv_pr = 10000;
int: min_online_offline = 2000;

int: max_diff_adv_online = 5000;
int: min_diff_pr_offline = -1000;

% Variables
var 0..max_advertising: advertising;
var 0..max_pr: pr;
var 0..max_online: online;
var 0..max_offline: offline;

var 0..(cost_advertising*max_advertising + cost_pr*max_pr + cost_online*max_online + cost_offline*max_offline): total_cost;

% Constraints
constraint advertising + pr <= max_adv_pr;
constraint online + offline >= min_online_offline;

constraint abs(advertising - online) <= max_diff_adv_online;
constraint pr - offline >= min_diff_pr_offline;

% Objective
constraint total_cost = cost_advertising*advertising + cost_pr*pr + cost_online*online + cost_offline*offline;
solve minimize total_cost;