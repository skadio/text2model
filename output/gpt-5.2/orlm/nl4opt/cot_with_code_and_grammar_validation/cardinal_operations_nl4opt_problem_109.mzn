% Parameters
int: masks_small = 25;
int: masks_large = 45;
int: min_total_masks = 750;
int: min_large_boxes = 5;
int: small_to_large_ratio = 3;

% Upper bounds (safe, derived from minimum requirement)
int: max_small_boxes = min_total_masks div masks_small + 100;
int: max_large_boxes = min_total_masks div masks_large + 100;

% Variables
var 0..max_small_boxes: s;  % number of small boxes
var 0..max_large_boxes: l;  % number of large boxes

% Constraints
constraint l >= min_large_boxes;
constraint s >= small_to_large_ratio * l;
constraint masks_small * s + masks_large * l >= min_total_masks;

% Objective
solve minimize s + l;