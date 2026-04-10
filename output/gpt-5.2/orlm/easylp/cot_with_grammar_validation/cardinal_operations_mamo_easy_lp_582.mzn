% Parameters
int: budget = 5000;

int: cost_tv = 200;
int: cost_radio = 150;
int: cost_online = 100;
int: cost_offline = 50;

int: tv_max = 2500;
int: radio_max = 2000;
int: online_max = 1200;

int: offline_min = 800;
int: tv_min = 1500;

int: diff_tv_radio_min = 1000;
int: online_over_offline_max = 300;

% Variables
var tv_min..tv_max: spend_tv;
var 0..radio_max: spend_radio;
var 0..online_max: spend_online;
var offline_min..budget: spend_offline;

var 0..(cost_tv*tv_max + cost_radio*radio_max + cost_online*online_max + cost_offline*budget): total_cost;

% Constraints
constraint spend_tv + spend_radio + spend_online + spend_offline = budget;

constraint abs(spend_tv - spend_radio) >= diff_tv_radio_min;

constraint spend_online - spend_offline <= online_over_offline_max;

constraint spend_tv >= tv_min;

constraint total_cost =
  cost_tv*spend_tv + cost_radio*spend_radio + cost_online*spend_online + cost_offline*spend_offline;

% Objective
solve minimize total_cost;