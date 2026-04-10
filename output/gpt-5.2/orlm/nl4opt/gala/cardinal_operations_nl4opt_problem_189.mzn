% Juice vitamin optimization (all data embedded)

include "globals.mzn";

% Data
int: vitD_orange = 10;
int: vitC_orange = 8;

int: vitD_apple  = 12;
int: vitC_apple  = 6;

int: min_orange = 3;
int: apple_ratio = 3;          % apple >= 3 * orange
int: max_vitC = 300;

% Decision variables: number of boxes
var 0..max_vitC div min(vitC_orange, vitC_apple): orange;
var 0..max_vitC div min(vitC_orange, vitC_apple): apple;

% Constraints
constraint orange >= min_orange;
constraint apple >= apple_ratio * orange;
constraint vitC_orange * orange + vitC_apple * apple <= max_vitC;

% Objective: maximize total vitamin D
var int: total_vitD = vitD_orange * orange + vitD_apple * apple;
solve maximize total_vitD;

output [
  "orange_boxes = ", show(orange), "\n",
  "apple_boxes  = ", show(apple), "\n",
  "total_vitC   = ", show(vitC_orange * orange + vitC_apple * apple), "\n",
  "total_vitD   = ", show(total_vitD), "\n"
];