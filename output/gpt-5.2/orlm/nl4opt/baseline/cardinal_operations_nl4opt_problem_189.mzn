% Juice diet optimization: maximize vitamin D intake

int: vitD_orange = 10;
int: vitC_orange = 8;

int: vitD_apple  = 12;
int: vitC_apple  = 6;

int: min_orange = 3;
int: max_vitC = 300;

% Decision variables: number of boxes (nonnegative integers)
var 0..1000: orange;
var 0..1000: apple;

% Constraints
constraint orange >= min_orange;
constraint apple >= 3 * orange;              % at least 3 times as many apple as orange
constraint vitC_orange * orange + vitC_apple * apple <= max_vitC;

% Objective: maximize total vitamin D
var int: total_vitD = vitD_orange * orange + vitD_apple * apple;
solve maximize total_vitD;

output [
  "orange_boxes = ", show(orange), "\n",
  "apple_boxes  = ", show(apple), "\n",
  "total_vitD   = ", show(total_vitD), "\n",
  "total_vitC   = ", show(vitC_orange * orange + vitC_apple * apple), "\n"
];