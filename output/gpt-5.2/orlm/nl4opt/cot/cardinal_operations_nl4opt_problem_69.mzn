% Parameters (with values embedded)
int: wide_capacity = 25;
int: narrow_capacity = 15;
int: min_flow = 900;
int: min_wide = 5;

% Variables
var 0..200: wide_pipes;
var 0..200: narrow_pipes;
var 0..400: total_pipes;

% Constraints
constraint wide_pipes >= min_wide;

% Wide pipes can be at most a third the number of narrow pipes: wide <= narrow/3  <=>  3*wide <= narrow
constraint 3 * wide_pipes <= narrow_pipes;

% Minimum required flow
constraint wide_capacity * wide_pipes + narrow_capacity * narrow_pipes >= min_flow;

% Total pipes definition
constraint total_pipes = wide_pipes + narrow_pipes;

% Objective
solve minimize total_pipes;