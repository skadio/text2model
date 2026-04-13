% Parameters
int: masks_per_small = 25;          % Masks per small box
int: masks_per_large = 45;          % Masks per large box
int: min_total_masks = 750;         % Minimum required masks to distribute
int: min_large_boxes = 5;           % Minimum number of large boxes
int: small_to_large_ratio = 3;      % Small boxes must be at least this multiple of large boxes

% Variable upper bounds (safe bounds based on minimum masks requirement)
int: max_small_boxes = min_total_masks div masks_per_small + 100; % loose safe upper bound
int: max_large_boxes = min_total_masks div masks_per_large + 100; % loose safe upper bound

% Variables
var 0..max_small_boxes: small_boxes;   % Number of small boxes to use
var 0..max_large_boxes: large_boxes;   % Number of large boxes to use
var 0..(max_small_boxes + max_large_boxes): total_boxes; % Total number of boxes used

% Constraints

% --- Total masks requirement ---
% Ensure shipped masks meet or exceed the minimum demand.
constraint
  masks_per_small * small_boxes + masks_per_large * large_boxes >= min_total_masks;

% --- Small-to-large box ratio requirement ---
% Small boxes must be at least 'small_to_large_ratio' times the number of large boxes.
constraint
  small_boxes >= small_to_large_ratio * large_boxes;

% --- Minimum number of large boxes ---
% At least 'min_large_boxes' large boxes must be used.
constraint
  large_boxes >= min_large_boxes;

% --- Total boxes definition ---
% Define total_boxes as the sum of small and large boxes.
constraint
  total_boxes = small_boxes + large_boxes;

% Objective
solve minimize total_boxes;