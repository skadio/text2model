% Pain killer dosage optimization (all data embedded)

% Decision variables: number of doses (assumed nonnegative integers)
var 0..100: d1;   % doses of pain killer 1
var 0..100: d2;   % doses of pain killer 2

% Coefficients (units per dose)
float: legs1  = 0.5;
float: back1  = 0.8;
float: sleep1 = 0.3;

float: legs2  = 0.7;
float: back2  = 0.4;
float: sleep2 = 0.6;

% Constraints
constraint sleep1 * int2float(d1) + sleep2 * int2float(d2) <= 8.0;
constraint legs1  * int2float(d1) + legs2  * int2float(d2) >= 4.0;

% Objective: maximize medicine delivered to the back
var float: backDelivered = back1 * int2float(d1) + back2 * int2float(d2);

solve maximize backDelivered;

output [
  "doses_killer1 = ", show(d1), "\n",
  "doses_killer2 = ", show(d2), "\n",
  "legsDelivered = ", show(legs1 * int2float(d1) + legs2 * int2float(d2)), "\n",
  "sleepDelivered = ", show(sleep1 * int2float(d1) + sleep2 * int2float(d2)), "\n",
  "backDelivered = ", show(backDelivered), "\n"
];