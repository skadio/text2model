% Parameters
int: small_capacity = 25;
int: large_capacity = 45;
int: min_masks = 750;
int: min_large = 5;
int: small_at_least_times_large = 3;

% Variables
var 0..(min_masks div small_capacity + 1): small_boxes;
var min_large..(min_masks div large_capacity + 1): large_boxes;
var 0..(min_masks div min(small_capacity, large_capacity) + 2): total_boxes;

% Constraints
constraint total_boxes = small_boxes + large_boxes;

constraint small_boxes >= small_at_least_times_large * large_boxes;

constraint small_capacity * small_boxes + large_capacity * large_boxes >= min_masks;

% Objective
solve minimize total_boxes;