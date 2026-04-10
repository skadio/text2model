% Parameters
int: cost_online = 50;
int: cost_offline = 70;
int: cost_event = 90;

int: min_total_effort = 1000;
int: max_diff_online_half_offline = 500;
int: min_offline_minus_event = 200;
int: max_online_plus_event = 1200;

int: max_budget_online = 800;
int: max_budget_offline = 700;
int: max_budget_event = 600;

% Variables
var 0..max_budget_online: online;
var 0..max_budget_offline: offline;
var 0..max_budget_event: event;

% Constraints
constraint online + offline + event >= min_total_effort;

constraint abs(2*online - offline) <= 2*max_diff_online_half_offline;

constraint offline - event >= min_offline_minus_event;

constraint online + event <= max_online_plus_event;

% Objective
solve minimize cost_online*online + cost_offline*offline + cost_event*event;