% Parameters
int: cost_online = 50;          % cost per unit effectiveness for online marketing
int: cost_offline = 70;         % cost per unit effectiveness for offline marketing
int: cost_event = 90;           % cost per unit effectiveness for event marketing

int: min_total_effort = 1000;   % minimum total effort required

int: max_balance_diff = 500;       % balance limit for |online - (offline/2)|
int: min_offline_over_event = 200; % offline - event >= 200
int: max_online_plus_event = 1200; % online + event <= 1200

int: max_online_budget = 800;   % 0..800 effort units allowed for online
int: max_offline_budget = 700;  % 0..700 effort units allowed for offline
int: max_event_budget = 600;    % 0..600 effort units allowed for event


% Variables
var 0..max_online_budget: online_effort;     % integer effort units for online marketing
var 0..max_offline_budget: offline_effort;   % integer effort units for offline marketing
var 0..max_event_budget: event_effort;       % integer effort units for event marketing

% Upper bound is the max possible cost given max efforts and per-unit costs
var 0..(cost_online*max_online_budget
      + cost_offline*max_offline_budget
      + cost_event*max_event_budget): total_cost;


% Constraints
% Total effort requirement: ensure sufficient market coverage
constraint
  online_effort + offline_effort + event_effort >= min_total_effort;

% Balance constraint: |online - (offline/2)| <= max_balance_diff
% Avoid division by using: |2*online - offline| <= 2*max_balance_diff
constraint
  abs(2 * online_effort - offline_effort) <= 2 * max_balance_diff;

% Channel emphasis constraint: offline must exceed event by at least min_offline_over_event
constraint
  offline_effort - event_effort >= min_offline_over_event;

% Logistical limitation: combined online and event efforts cannot exceed max_online_plus_event
constraint
  online_effort + event_effort <= max_online_plus_event;

% Total cost definition
constraint
  total_cost = cost_online * online_effort
             + cost_offline * offline_effort
             + cost_event * event_effort;


% Objective
solve minimize total_cost;