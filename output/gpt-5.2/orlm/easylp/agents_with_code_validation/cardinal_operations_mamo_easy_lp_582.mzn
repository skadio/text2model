% Parameters
int: total_budget = 5000;                  % Total budget available ($)

% Unit costs ($ per unit) for each advertising channel
int: cost_tv      = 200;
int: cost_radio   = 150;
int: cost_online  = 100;
int: cost_offline = 50;

% Channel-specific spending bounds ($)
int: tv_min = 0;
int: tv_max = 2500;

int: radio_min = 0;
int: radio_max = 2000;

int: online_min = 0;
int: online_max = 1200;

int: offline_min = 800;                   % At least $800 on offline
int: offline_max = total_budget;          % No explicit upper bound; cannot exceed total budget

% Strategic constraints (all in $)
int: min_diff_tv_radio = 1000;            % |TV - Radio| >= 1000
int: max_online_over_offline = 300;       % Online - Offline <= 300
int: min_tv_spend = 1500;                 % At least $1500 on TV

% Variables (spending amounts in $, integer)
var tv_min..tv_max: spend_tv;
var radio_min..radio_max: spend_radio;
var online_min..online_max: spend_online;
var offline_min..offline_max: spend_offline;

var 0..total_budget: total_spend;

% Upper bound for total_cost based on max feasible spending per channel within bounds
int: max_total_cost =
    cost_tv * tv_max +
    cost_radio * radio_max +
    cost_online * online_max +
    cost_offline * offline_max;

var 0..max_total_cost: total_cost;

% Constraints
constraint total_spend = spend_tv + spend_radio + spend_online + spend_offline;
constraint total_spend <= total_budget;

constraint abs(spend_tv - spend_radio) >= min_diff_tv_radio;
constraint spend_online - spend_offline <= max_online_over_offline;
constraint spend_tv >= min_tv_spend;

constraint total_cost =
    cost_tv * spend_tv +
    cost_radio * spend_radio +
    cost_online * spend_online +
    cost_offline * spend_offline;

% Objective
solve minimize total_cost;

output [
  "spend_tv=", show(spend_tv), "\n",
  "spend_radio=", show(spend_radio), "\n",
  "spend_online=", show(spend_online), "\n",
  "spend_offline=", show(spend_offline), "\n",
  "total_spend=", show(total_spend), "\n",
  "total_cost=", show(total_cost), "\n"
];