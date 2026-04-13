% Parameters
int: letters_per_min_dual   = 50;   % letters stamped per minute by a dual machine
int: letters_per_min_single = 30;   % letters stamped per minute by a single machine

int: glue_per_min_dual      = 20;   % glue units per minute used by a dual machine
int: glue_per_min_single    = 15;   % glue units per minute used by a single machine

int: min_letters_per_min    = 300;  % minimum required letters stamped per minute
int: max_glue_per_min       = 135;  % maximum allowed glue units per minute

% Upper bounds derived from glue limit (safe, finite bounds)
int: max_dual   = max_glue_per_min div glue_per_min_dual;     % floor(135/20)=6
int: max_single = max_glue_per_min div glue_per_min_single;   % floor(135/15)=9

% Variables
var 0..max_dual:   num_dual;     % number of dual model machines to buy
var 0..max_single: num_single;   % number of single model machines to buy

var 0..(max_dual + max_single): total_machines; % total number of machines

% Constraints

% Link total_machines to the decision variables
constraint
  total_machines = num_dual + num_single;

% Meet minimum required stamping throughput (letters per minute)
constraint
  letters_per_min_dual * num_dual + letters_per_min_single * num_single >= min_letters_per_min;

% Respect maximum glue usage per minute
constraint
  glue_per_min_dual * num_dual + glue_per_min_single * num_single <= max_glue_per_min;

% Single machines must be more than dual machines (quieter requirement)
constraint
  num_single > num_dual;

% Objective
solve minimize total_machines;