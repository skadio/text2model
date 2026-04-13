% Parameters
int: wide_capacity = 25;
int: narrow_capacity = 15;
int: min_total_flow = 900;
int: min_wide = 5;

% Variables
var int: wide;
var int: narrow;
var int: total_pipes;

% Constraints
constraint wide >= min_wide;
constraint narrow >= 0;

constraint wide <= narrow div 3;

constraint wide_capacity * wide + narrow_capacity * narrow >= min_total_flow;

constraint total_pipes = wide + narrow;

% Objective
solve minimize total_pipes;