float: leg1 = 0.5;
float: back1 = 0.8;
float: sleep1 = 0.3;

float: leg2 = 0.7;
float: back2 = 0.4;
float: sleep2 = 0.6;

float: max_sleep = 8.0;
float: min_leg = 4.0;

var float: x1;
var float: x2;

constraint x1 >= 0.0;
constraint x2 >= 0.0;

constraint sleep1 * x1 + sleep2 * x2 <= max_sleep;
constraint leg1 * x1 + leg2 * x2 >= min_leg;

solve maximize back1 * x1 + back2 * x2;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "back = ", show(back1 * x1 + back2 * x2), "\n"
];