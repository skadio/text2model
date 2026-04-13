include "globals.mzn";

/* Data (all embedded as requested) */
int: budget = 5000;

int: cost_tv      = 200;
int: cost_radio   = 150;
int: cost_online  = 100;
int: cost_offline = 50;

/* Channel spending bounds (in dollars) */
int: tv_min = 0;     int: tv_max = 2500;
int: radio_min = 0;  int: radio_max = 2000;
int: online_min = 0; int: online_max = 1200;
int: offline_min = 800; int: offline_max = budget; % no upper limit given; budget is a safe cap

/* Decision variables: spending per channel (whole dollars) */
var tv_min..tv_max: tv;
var radio_min..radio_max: radio;
var online_min..online_max: online;
var offline_min..offline_max: offline;

/* Constraints */
constraint tv + radio + online + offline = budget;

/* Difference between TV and radio at least $1000 */
constraint abs(tv - radio) >= 1000;

/* Online cannot exceed offline by more than $300 */
constraint online - offline <= 300;

/* At least $1500 to TV */
constraint tv >= 1500;

/* Objective: minimize total "cost" per unit-spend (as given) */
var int: total_cost = cost_tv*tv + cost_radio*radio + cost_online*online + cost_offline*offline;
solve minimize total_cost;

output [
  "tv=$", show(tv), " radio=$", show(radio), " online=$", show(online), " offline=$", show(offline), "\n",
  "budget=$", show(budget), "\n",
  "total_cost=$", show(total_cost), "\n"
];