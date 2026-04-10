% Mask shipping optimization (all data embedded)

int: small_capacity = 25;
int: large_capacity = 45;

int: min_masks = 750;
int: min_large_boxes = 5;
int: small_at_least_times_large = 3;

% Decision variables: number of small and large boxes
var 0..1000: s; % small boxes
var 0..1000: l; % large boxes

constraint l >= min_large_boxes;
constraint s >= small_at_least_times_large * l;
constraint small_capacity * s + large_capacity * l >= min_masks;

solve minimize s + l;

output [
  "small_boxes = ", show(s), "\n",
  "large_boxes = ", show(l), "\n",
  "total_boxes = ", show(s + l), "\n",
  "total_masks = ", show(small_capacity * s + large_capacity * l), "\n"
];