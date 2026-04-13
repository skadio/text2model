% Parameters
int: cost_online = 50;          % $ per unit effectiveness for online marketing
int: cost_offline = 70;         % $ per unit effectiveness for offline marketing
int: cost_event = 90;           % $ per unit effectiveness for event marketing

int: min_total_effort = 1000;   % minimum total effort required

int: max_balance_diff = 500;        % |online - (offline/2)| <= 500 (handled via linear form)
int: min_offline_minus_event = 200; % offline - event >= 200
int: max_online_plus_event = 1200;  % online + event <= 1200

int: online_lb = 0;  int: online_ub = 800;   % bounds on online effort
int: offline_lb = 0; int: offline_ub = 700;  % bounds on offline effort
int: event_lb = 0;   int: event_ub = 600;    % bounds on event effort


% Variables
var online_lb..online_ub: online_effort;      % integer effort in online marketing
var offline_lb..offline_ub: offline_effort;   % integer effort in offline marketing
var event_lb..event_ub: event_effort;         % integer effort in event marketing

var int: total_cost;                          % total campaign cost in dollars


% Constraints
% --- Total effort requirement (market coverage) ---
constraint
  online_effort + offline_effort + event_effort >= min_total_effort;

% --- Balanced approach constraint: |online - offline/2| <= max_balance_diff ---
% Avoid fractional division by multiplying by 2: |2*online - offline| <= 2*max_balance_diff
constraint
  2 * online_effort - offline_effort <= 2 * max_balance_diff;
constraint
  offline_effort - 2 * online_effort <= 2 * max_balance_diff;

% --- Offline must exceed event by at least min_offline_minus_event (wider reach) ---
constraint
  offline_effort - event_effort >= min_offline_minus_event;

% --- Logistical limitation on combined online and event efforts ---
constraint
  online_effort + event_effort <= max_online_plus_event;

% --- Total cost definition (linking cost variable to efforts) ---
constraint
  total_cost =
    cost_online * online_effort +
    cost_offline * offline_effort +
    cost_event * event_effort;


% Objective
solve minimize total_cost;