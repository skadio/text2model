% Parameters
int: metal_available = 800;      % Total units of metal available
int: acid_available  = 750;      % Total units of acid available

int: metal_alpha = 3;            % Metal required per alpha experiment
int: acid_alpha  = 5;            % Acid required per alpha experiment
int: elec_alpha  = 8;            % Electricity produced per alpha experiment

int: metal_beta = 5;             % Metal required per beta experiment
int: acid_beta  = 4;             % Acid required per beta experiment
int: elec_beta  = 10;            % Electricity produced per beta experiment

% Variables
var 0..(metal_available div metal_alpha): x_alpha;  % Number of alpha experiments
var 0..(metal_available div metal_beta):  x_beta;   % Number of beta experiments

% Upper bound uses only metal-based maxima (safe, possibly loose); objective will tighten it
var 0..(elec_alpha * (metal_available div metal_alpha)
      + elec_beta  * (metal_available div metal_beta)): total_electricity; % Total electricity produced

% Constraints
% Link total_electricity to the number of experiments performed
constraint
  total_electricity = elec_alpha * x_alpha + elec_beta * x_beta;

% Resource capacity constraints: do not exceed available metal
constraint
  metal_alpha * x_alpha + metal_beta * x_beta <= metal_available;

% Resource capacity constraints: do not exceed available acid
constraint
  acid_alpha * x_alpha + acid_beta * x_beta <= acid_available;

% Objective
solve maximize total_electricity;