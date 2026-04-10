% Parameters
int: budget = 5000;

int: cost_tv = 200;
int: cost_radio = 150;
int: cost_online = 100;
int: cost_offline = 50;

int: tv_min = 0;
int: tv_max = 2500;

int: radio_min = 0;
int: radio_max = 2000;

int: online_min = 0;
int: online_max = 1200;

int: offline_min = 800;

int: min_tv_spend = 1500;
int: min_diff_tv_radio = 1000;
int: max_online_over_offline = 300;

% Variables
var tv_min..tv_max: tv_spend;
var radio_min..radio_max: radio_spend;
var online_min..online_max: online_spend;
var offline_min..budget: offline_spend;

var 0..budget: total_spend;

% Constraints
constraint total_spend = tv_spend + radio_spend + online_spend + offline_spend;
constraint total_spend <= budget;

constraint abs(tv_spend - radio_spend) >= min_diff_tv_radio;
constraint online_spend - offline_spend <= max_online_over_offline;

constraint tv_spend >= min_tv_spend;

% Objective
solve minimize total_spend;