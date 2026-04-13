% Parameters
int: wide_capacity = 25;
int: narrow_capacity = 15;
int: min_total_flow = 900;
int: min_wide = 5;

% Variables
var 0..1000: wide_pipes;
var 0..1000: narrow_pipes;

% Constraints
constraint wide_pipes >= min_wide;
constraint 3 * wide_pipes <= narrow_pipes;
constraint wide_capacity * wide_pipes + narrow_capacity * narrow_pipes >= min_total_flow;

% Objective
solve minimize wide_pipes + narrow_pipes;