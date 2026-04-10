int: red_avail = 80;
int: blue_avail = 70;
int: smelly_max = 10;

% Experiment requirements/outputs
int: red1 = 3;   int: blue1 = 4;   int: green1 = 5;   int: smelly1 = 1;
int: red2 = 5;   int: blue2 = 3;   int: green2 = 6;   int: smelly2 = 2;

var 0..1000: x1; % number of experiment 1
var 0..1000: x2; % number of experiment 2

constraint red1 * x1 + red2 * x2 <= red_avail;
constraint blue1 * x1 + blue2 * x2 <= blue_avail;
constraint smelly1 * x1 + smelly2 * x2 <= smelly_max;

var int: total_green = green1 * x1 + green2 * x2;

solve maximize total_green;

output [
  "experiment1 = ", show(x1), "\n",
  "experiment2 = ", show(x2), "\n",
  "total_green = ", show(total_green), "\n"
];