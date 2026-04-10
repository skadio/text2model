% Maple Oil blending/processing (LP with fractional tanks)

% Parameters
int: revenue_light = 550;
int: revenue_nonsticky = 750;
int: revenue_heavy = 950;

int: a_per_light = 3;
int: b_per_light = 3;

int: a_per_nonsticky = 6;
int: b_per_nonsticky = 2;

int: a_per_heavy = 9;
int: b_per_heavy = 3;

int: avail_a = 250;
int: avail_b = 150;

% Variables (allow full or partial tanks)
var float: x_light;
var float: x_nonsticky;
var float: x_heavy;

% Nonnegativity
constraint x_light >= 0.0;
constraint x_nonsticky >= 0.0;
constraint x_heavy >= 0.0;

% Resource constraints
constraint a_per_light * x_light + a_per_nonsticky * x_nonsticky + a_per_heavy * x_heavy <= avail_a;
constraint b_per_light * x_light + b_per_nonsticky * x_nonsticky + b_per_heavy * x_heavy <= avail_b;

% Objective: maximize net revenue
solve maximize revenue_light * x_light + revenue_nonsticky * x_nonsticky + revenue_heavy * x_heavy;