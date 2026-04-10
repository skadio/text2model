% Parameters
int: letters_per_min_dual   = 50;   % letters stamped per minute by one dual machine
int: letters_per_min_single = 30;   % letters stamped per minute by one single machine

int: glue_per_min_dual      = 20;   % glue units used per minute by one dual machine
int: glue_per_min_single    = 15;   % glue units used per minute by one single machine

int: min_letters_per_min    = 300;  % minimum required throughput (letters per minute)
int: max_glue_per_min       = 135;  % maximum allowed glue usage (units per minute)

% Safe explicit upper bounds for decision variables (derived from glue constraint)
int: dual_max   = max_glue_per_min div glue_per_min_dual;     % = 6
int: single_max = max_glue_per_min div glue_per_min_single;   % = 9

% Variables
var 0..dual_max: n_dual;       % number of dual model stamping machines to buy
var 0..single_max: n_single;   % number of single model stamping machines to buy

% Constraints
% Throughput requirement: stamp at least the minimum letters per minute
constraint
  letters_per_min_dual * n_dual + letters_per_min_single * n_single
  >= min_letters_per_min;

% Glue usage limit: use at most the maximum glue units per minute
constraint
  glue_per_min_dual * n_dual + glue_per_min_single * n_single
  <= max_glue_per_min;

% Quietness requirement: number of single machines must exceed number of dual machines
constraint
  n_single > n_dual;

% Objective
solve minimize n_dual + n_single;