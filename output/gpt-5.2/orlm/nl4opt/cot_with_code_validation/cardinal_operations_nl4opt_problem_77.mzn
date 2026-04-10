% Data (embedded)
float: heart_rate_m1 = 0.5;
float: brain_rate_m1 = 0.8;
float: waste_rate_m1 = 0.3;

float: heart_rate_m2 = 0.3;
float: brain_rate_m2 = 1.0;
float: waste_rate_m2 = 0.5;

float: heart_max = 8.0;
float: brain_min = 4.0;

% Decision variables (bounded to avoid Float::linear limits issues)
var 0.0..(heart_max / heart_rate_m1): m1_minutes; % since m2_minutes >= 0
var 0.0..(heart_max / heart_rate_m2): m2_minutes; % since m1_minutes >= 0

var 0.0..(waste_rate_m1*(heart_max/heart_rate_m1) + waste_rate_m2*(heart_max/heart_rate_m2)): total_waste;

% Constraints
constraint heart_rate_m1 * m1_minutes + heart_rate_m2 * m2_minutes <= heart_max;
constraint brain_rate_m1 * m1_minutes + brain_rate_m2 * m2_minutes >= brain_min;

constraint total_waste = waste_rate_m1 * m1_minutes + waste_rate_m2 * m2_minutes;

% Objective
solve minimize total_waste;

output [
  "m1_minutes = ", show(m1_minutes), "\n",
  "m2_minutes = ", show(m2_minutes), "\n",
  "total_waste = ", show(total_waste), "\n"
];