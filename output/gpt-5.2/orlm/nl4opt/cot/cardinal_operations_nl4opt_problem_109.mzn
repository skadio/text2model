% Parameters (with values embedded)
int: masks_per_small = 25;
int: masks_per_large = 45;
int: min_masks = 750;
int: min_large_boxes = 5;
int: small_to_large_ratio = 3;

% Upper bounds derived from meeting demand using only one type
int: max_small = (min_masks div masks_per_small) + 100; % safe buffer
int: max_large = (min_masks div masks_per_large) + 100; % safe buffer

% Variables
var 0..max_small: small_boxes;
var 0..max_large: large_boxes;
var 0..(max_small + max_large): total_boxes;

% Constraints
constraint total_boxes = small_boxes + large_boxes;

% At least 750 masks shipped
constraint masks_per_small * small_boxes + masks_per_large * large_boxes >= min_masks;

% At least three times as many small boxes as large boxes
constraint small_boxes >= small_to_large_ratio * large_boxes;

% At least 5 large boxes
constraint large_boxes >= min_large_boxes;

% Objective
solve minimize total_boxes;