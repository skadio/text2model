% Parameters
int: metal_available = 800;            % total units of metal available
int: acid_available  = 750;            % total units of acid available

int: metal_alpha = 3;                  % metal needed per alpha experiment
int: acid_alpha  = 5;                  % acid needed per alpha experiment
int: elec_alpha  = 8;                  % electricity produced per alpha experiment

int: metal_beta  = 5;                  % metal needed per beta experiment
int: acid_beta   = 4;                  % acid needed per beta experiment
int: elec_beta   = 10;                 % electricity produced per beta experiment

% Variables
var 0..(metal_available div metal_alpha): n_alpha;  % number of alpha experiments
var 0..(metal_available div metal_beta):  n_beta;   % number of beta experiments

% Upper bound is a safe bound based on metal-only maxima (could be tightened, but is valid)
var 0..(elec_alpha * (metal_available div metal_alpha) + elec_beta * (metal_available div metal_beta)):
    total_electricity;

% Constraints
% Resource constraints: do not exceed available metal
constraint
  metal_alpha * n_alpha + metal_beta * n_beta <= metal_available;

% Resource constraints: do not exceed available acid
constraint
  acid_alpha * n_alpha + acid_beta * n_beta <= acid_available;

% Link total electricity to chosen numbers of experiments
constraint
  total_electricity = elec_alpha * n_alpha + elec_beta * n_beta;

% Objective
solve maximize total_electricity;