% Parameters (with values embedded)
int: revenue_light = 550;
int: revenue_nonsticky = 750;
int: revenue_heavy = 950;

int: avail_A = 250;
int: avail_B = 150;

int: reqA_light = 3;
int: reqB_light = 3;

int: reqA_nonsticky = 6;
int: reqB_nonsticky = 2;

int: reqA_heavy = 9;
int: reqB_heavy = 3;

% Variables
var 0..83: x_light;        % tanks of light oil (can be partial, modeled as continuous via float is not allowed; use integer units)
var 0..41: x_nonsticky;    % tanks of non-sticky oil
var 0..27: x_heavy;        % tanks of heavy oil

% Constraints
constraint
  reqA_light * x_light + reqA_nonsticky * x_nonsticky + reqA_heavy * x_heavy <= avail_A;

constraint
  reqB_light * x_light + reqB_nonsticky * x_nonsticky + reqB_heavy * x_heavy <= avail_B;

% Objective
solve maximize revenue_light * x_light + revenue_nonsticky * x_nonsticky + revenue_heavy * x_heavy;