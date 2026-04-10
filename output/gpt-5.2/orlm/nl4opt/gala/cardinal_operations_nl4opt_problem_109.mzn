include "globals.mzn";

% Data (embedded as required)
int: smallCap = 25;
int: largeCap = 45;
int: minMasks = 750;
int: minLarge = 5;

% Decision variables: number of boxes of each type
% Upper bounds are safe: using only small boxes would need 30; add slack.
var 0..200: small;
var 0..200: large;

% Constraints
constraint smallCap * small + largeCap * large >= minMasks;
constraint small >= 3 * large;
constraint large >= minLarge;

% Objective: minimize total number of boxes
var 0..400: totalBoxes = small + large;
solve minimize totalBoxes;

output [
  "small_boxes = ", show(small), "\n",
  "large_boxes = ", show(large), "\n",
  "total_boxes = ", show(totalBoxes), "\n",
  "total_masks = ", show(smallCap*small + largeCap*large), "\n"
];