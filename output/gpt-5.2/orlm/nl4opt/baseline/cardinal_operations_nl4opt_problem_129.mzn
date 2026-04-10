int: cap4 = 60;
int: cap3 = 40;
int: pol4 = 30;
int: pol3 = 15;

int: min_luggage = 1000;
int: max_pollution = 430;

var 0..1000: x4; % number of 4-wheelers
var 0..1000: x3; % number of 3-wheelers

constraint cap4 * x4 + cap3 * x3 >= min_luggage;
constraint pol4 * x4 + pol3 * x3 <= max_pollution;

solve minimize x4 + x3;

output [
  "4-wheelers = ", show(x4), "\n",
  "3-wheelers = ", show(x3), "\n",
  "total vehicles = ", show(x4 + x3), "\n",
  "luggage moved = ", show(cap4 * x4 + cap3 * x3), "\n",
  "pollution = ", show(pol4 * x4 + pol3 * x3), "\n"
];