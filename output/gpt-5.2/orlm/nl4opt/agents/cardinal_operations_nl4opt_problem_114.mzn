% Parameters
int: throat_time = 5;              % minutes per throat swab
int: nasal_time  = 3;              % minutes per nasal swab
int: min_nasal   = 30;             % minimum required nasal swabs
int: throat_ratio = 4;             % throat swabs must be at least 4x nasal swabs
int: total_time  = 20000;          % total available clinic minutes

% Upper bounds derived from total time (safe integer bounds)
int: max_throat = total_time div throat_time;
int: max_nasal  = total_time div nasal_time;

% Variables
var 0..max_throat: throat_swabs;                 % number of throat swabs
var 0..max_nasal:  nasal_swabs;                  % number of nasal swabs
var 0..(max_throat + max_nasal): total_patients; % total patients seen (one swab per patient)

% Constraints

% Link total_patients to the number of swabs (one swab per patient)
constraint
  total_patients = throat_swabs + nasal_swabs;

% Total operational time limit (in minutes)
constraint
  throat_time * throat_swabs + nasal_time * nasal_swabs <= total_time;

% Minimum number of nasal swabs required
constraint
  nasal_swabs >= min_nasal;

% Throat-to-nasal swab ratio requirement
constraint
  throat_swabs >= throat_ratio * nasal_swabs;

% Objective
solve maximize total_patients;