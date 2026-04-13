% Parameters (with values embedded)
int: cost_online = 50;
int: cost_offline = 70;
int: cost_event = 90;

int: min_total_effort = 1000;
int: max_diff = 500;
int: min_offline_minus_event = 200;
int: max_online_plus_event = 1200;

int: max_online = 800;
int: max_offline = 700;
int: max_event = 600;

% Variables
var 0..max_online: online;
var 0..max_offline: offline;
var 0..max_event: event;

var int: total_cost;

% Constraints
constraint online + offline + event >= min_total_effort;

% | online - 0.5 * offline | <= 500  ->  |2*online - offline| <= 1000
constraint abs(2 * online - offline) <= 2 * max_diff;

constraint offline - event >= min_offline_minus_event;

constraint online + event <= max_online_plus_event;

% Cost definition (already integral)
constraint total_cost = cost_online * online + cost_offline * offline + cost_event * event;

% Objective
solve minimize total_cost;