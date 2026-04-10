% Pain killer dosage optimization (embedded data)

% Decision variables: number of doses (assume nonnegative integers)
var 0..100: x1; % doses of pain killer 1
var 0..100: x2; % doses of pain killer 2

% Data (per dose)
float: legs1 = 0.5;
float: back1 = 0.8;
float: sleep1 = 0.3;

float: legs2 = 0.7;
float: back2 = 0.4;
float: sleep2 = 0.6;

% Requirements
float: max_sleep = 8.0;
float: min_legs  = 4.0;

% Constraints
constraint sleep1 * x1 + sleep2 * x2 <= max_sleep;
constraint legs1 * x1 + legs2 * x2 >= min_legs;

% Objective: maximize medicine delivered to the back
var float: back_total = back1 * x1 + back2 * x2;
solve maximize back_total;

output [
  "doses_painkiller1 = ", show(x1), "\n",
  "doses_painkiller2 = ", show(x2), "\n",
  "legs_total = ", show(legs1 * x1 + legs2 * x2), "\n",
  "sleep_total = ", show(sleep1 * x1 + sleep2 * x2), "\n",
  "back_total = ", show(back_total), "\n"
];