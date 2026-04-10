int: pill_time = 10;
int: shot_time = 20;
int: total_time = 10000;

int: min_pills = 30;

var 0..total_time div pill_time: pills;
var 0..total_time div shot_time: shots;

constraint pills >= min_pills;
constraint shots >= 3 * pills;
constraint pill_time * pills + shot_time * shots <= total_time;

solve maximize pills + shots;

output [
  "pills=", show(pills), "\n",
  "shots=", show(shots), "\n",
  "total_patients=", show(pills + shots), "\n",
  "time_used=", show(pill_time * pills + shot_time * shots), "\n"
];