% Parameters
int: cost_online = 50;
int: cost_offline = 70;
int: cost_event = 90;

int: min_total_effort = 1000;

int: diff_limit = 500;
int: offline_minus_event_min = 200;
int: online_plus_event_max = 1200;

int: max_budget_online = 800;
int: max_budget_offline = 700;
int: max_budget_event = 600;

% Variables
var 0..max_budget_online: online;
var 0..max_budget_offline: offline;
var 0..max_budget_event: event;

var 0..(max_budget_online*cost_online + max_budget_offline*cost_offline + max_budget_event*cost_event): total_cost;

% Constraints
constraint online + offline + event >= min_total_effort;

constraint abs(2*online - offline) <= 2*diff_limit;

constraint offline - event >= offline_minus_event_min;

constraint online + event <= online_plus_event_max;

constraint total_cost = cost_online*online + cost_offline*offline + cost_event*event;

% Objective
solve minimize total_cost;