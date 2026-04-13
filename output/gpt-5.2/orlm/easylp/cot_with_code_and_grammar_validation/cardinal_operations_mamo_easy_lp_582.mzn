% Parameters
int: BUDGET = 5000;

int: cost_tv = 200;
int: cost_radio = 150;
int: cost_online = 100;
int: cost_offline = 50;

int: min_diff_tv_radio = 1000;
int: max_online_over_offline = 300;
int: min_tv_spend = 1500;

int: tv_lb = 0;
int: tv_ub = 2500;

int: radio_lb = 0;
int: radio_ub = 2000;

int: online_lb = 0;
int: online_ub = 1200;

int: offline_lb = 800;
int: offline_ub = BUDGET; % implied by total budget cap

% Variables
var tv_lb..tv_ub: tv_spend;
var radio_lb..radio_ub: radio_spend;
var online_lb..online_ub: online_spend;
var offline_lb..offline_ub: offline_spend;

var 0..BUDGET: total_spend;
var 0..(cost_tv*tv_ub + cost_radio*radio_ub + cost_online*online_ub + cost_offline*offline_ub): total_cost;

% Constraints
constraint total_spend = tv_spend + radio_spend + online_spend + offline_spend;
constraint total_spend <= BUDGET;

constraint abs(tv_spend - radio_spend) >= min_diff_tv_radio;

constraint online_spend - offline_spend <= max_online_over_offline;

constraint tv_spend >= min_tv_spend;

constraint total_cost =
  cost_tv * tv_spend +
  cost_radio * radio_spend +
  cost_online * online_spend +
  cost_offline * offline_spend;

% Objective
solve minimize total_cost;