int: meat_per_wrap = 5;
int: rice_per_wrap = 3;
int: time_per_wrap = 10;

int: meat_per_platter = 7;
int: rice_per_platter = 5;
int: time_per_platter = 8;

int: min_meat = 3000;
int: min_rice = 2500;

var 0..1000000: wraps;
var 0..1000000: platters;

constraint meat_per_wrap * wraps + meat_per_platter * platters >= min_meat;
constraint rice_per_wrap * wraps + rice_per_platter * platters >= min_rice;

constraint wraps >= 3 * platters;

var int: total_time = time_per_wrap * wraps + time_per_platter * platters;

solve minimize total_time;

output [
  "wraps=", show(wraps), "\n",
  "platters=", show(platters), "\n",
  "total_time=", show(total_time), "\n"
];