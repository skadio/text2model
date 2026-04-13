% Marketing budget allocation (integer efforts/units) - minimize total cost

% Data (embedded as requested)
int: cost_online = 50;
int: cost_offline = 70;
int: cost_event = 90;

int: min_total_effort = 1000;

int: max_diff_online_vs_half_offline = 500;  % |online - offline/2| <= 500
int: min_offline_minus_event = 200;          % offline - event >= 200
int: max_online_plus_event = 1200;           % online + event <= 1200

int: online_max = 800;
int: offline_max = 700;
int: event_max = 600;

% Decision variables (effort units; integer)
var 0..online_max: online;
var 0..offline_max: offline;
var 0..event_max: event;

% Constraints
constraint online + offline + event >= min_total_effort;

% Balanced approach: |online - offline/2| <= 500
% Use integer arithmetic: |2*online - offline| <= 1000
constraint abs(2 * online - offline) <= 2 * max_diff_online_vs_half_offline;

% Offline more than event by at least 200
constraint offline - event >= min_offline_minus_event;

% Logistical limitation
constraint online + event <= max_online_plus_event;

% Objective: minimize cost
var int: total_cost = cost_online * online + cost_offline * offline + cost_event * event;

solve minimize total_cost;

output [
  "online = ", show(online), "\n",
  "offline = ", show(offline), "\n",
  "event = ", show(event), "\n",
  "total_effort = ", show(online + offline + event), "\n",
  "total_cost = ", show(total_cost), "\n"
];