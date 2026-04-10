% Parameters (with values embedded)
int: manual_slices_per_min = 5;
int: auto_slices_per_min   = 8;

int: manual_grease_per_min = 3;
int: auto_grease_per_min   = 6;

int: min_slices_required   = 50;
int: max_grease_allowed    = 35;

% Upper bounds derived from constraints
int: max_manual = max_grease_allowed div manual_grease_per_min; % 11
int: max_auto   = max_grease_allowed div auto_grease_per_min;   % 5

% Variables
var 0..max_manual: manual_slicers;
var 0..max_auto: automatic_slicers;

% Constraints
constraint manual_slices_per_min * manual_slicers
         + auto_slices_per_min   * automatic_slicers
         >= min_slices_required;

constraint manual_grease_per_min * manual_slicers
         + auto_grease_per_min   * automatic_slicers
         <= max_grease_allowed;

constraint manual_slicers < automatic_slicers;

% Objective
solve minimize manual_slicers + automatic_slicers;