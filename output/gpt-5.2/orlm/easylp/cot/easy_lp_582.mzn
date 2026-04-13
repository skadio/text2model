% Parameters (with values embedded)
int: BUDGET = 5000;

int: cost_tv = 200;
int: cost_radio = 150;
int: cost_online = 100;
int: cost_offline = 50;

int: max_tv = 2500;
int: max_radio = 2000;
int: max_online = 1200;
int: min_offline = 800;

int: min_tv = 1500;

int: min_diff_tv_radio = 1000;
int: max_excess_online_over_offline = 300;

% Variables
var 0..max_tv: tv;
var 0..max_radio: radio;
var 0..max_online: online;
var min_offline..BUDGET: offline;

% Constraints
constraint tv + radio + online + offline = BUDGET;

% difference in spending between TV and radio is at least $1000
constraint abs(tv - radio) >= min_diff_tv_radio;

% online cannot exceed offline by more than $300  (online - offline <= 300)
constraint online - offline <= max_excess_online_over_offline;

% at least $1500 on TV
constraint tv >= min_tv;

% Objective
var int: total_cost = cost_tv*tv + cost_radio*radio + cost_online*online + cost_offline*offline;
solve minimize total_cost;

output [
  "tv=", show(tv), "\n",
  "radio=", show(radio), "\n",
  "online=", show(online), "\n",
  "offline=", show(offline), "\n",
  "total_cost=", show(total_cost), "\n"
];