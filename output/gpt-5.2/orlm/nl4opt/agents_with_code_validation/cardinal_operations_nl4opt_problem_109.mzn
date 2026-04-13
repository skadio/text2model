% Parameters
int: masks_per_small = 25;                 % masks per small box
int: masks_per_large = 45;                 % masks per large box
int: min_total_masks = 750;                % minimum masks to distribute
int: min_large_boxes = 5;                  % minimum number of large boxes required
int: small_to_large_ratio = 3;             % small boxes must be at least this times large boxes

% A safe upper bound on total boxes:
% - If all masks were shipped in small boxes: ceil(750/25) = 30 boxes
int: max_total_boxes = (min_total_masks + masks_per_small - 1) div masks_per_small;

% Variables
var 0..max_total_boxes: num_small_boxes;                 % number of small boxes used
var min_large_boxes..max_total_boxes: num_large_boxes;   % number of large boxes used
var 0..(2*max_total_boxes): total_boxes;                 % total number of boxes used

% Constraints

% Link total boxes to the sum of small and large boxes
constraint
  total_boxes = num_small_boxes + num_large_boxes;

% Ensure at least the required number of masks are distributed
constraint
  masks_per_small * num_small_boxes + masks_per_large * num_large_boxes >= min_total_masks;

% Enforce stacking/stocking rule: at least 3 times as many small boxes as large boxes
constraint
  num_small_boxes >= small_to_large_ratio * num_large_boxes;

% Minimum number of large boxes (also enforced by variable domain, repeated for clarity)
constraint
  num_large_boxes >= min_large_boxes;

% Objective
solve minimize total_boxes;