% Parameters
int: small_capacity = 25;
int: large_capacity = 45;
int: min_masks = 750;
int: min_large = 5;
int: small_at_least_times_large = 3;

% Variables
var 0..ceil(min_masks div small_capacity) + ceil(min_masks div large_capacity): small_boxes;
var min_large..ceil(min_masks div large_capacity) + ceil(min_masks div small_capacity): large_boxes;
var 0..2*(ceil(min_masks div small_capacity) + ceil(min_masks div large_capacity)): total_boxes;

% Constraints
constraint small_capacity * small_boxes + large_capacity * large_boxes >= min_masks;
constraint small_boxes >= small_at_least_times_large * large_boxes;

constraint total_boxes = small_boxes + large_boxes;

% Objective
solve minimize total_boxes;