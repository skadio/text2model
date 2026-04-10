% Parameters
int: probes_per_salinity = 3;              % Probes required per salinity test
int: probes_per_ph = 2;                    % Probes required per pH test
int: min_ph_tests = 250;                   % Minimum required number of pH tests
int: min_total_tests = 400;                % Minimum required total number of tests
float: max_ph_to_salinity_ratio = 1.5;     % pH tests must be at most this multiple of salinity tests (informational)

% Variables
var 0..100000: salinity_tests;             % Number of salinity tests performed
var 0..100000: ph_tests;                   % Number of pH tests performed
var 0..1000000: total_probes;              % Total probes used (objective helper)

% Constraints
% Link helper variable to the total number of probes used
constraint
  total_probes = probes_per_salinity * salinity_tests
              + probes_per_ph * ph_tests;

% Minimum required number of pH tests
constraint
  ph_tests >= min_ph_tests;

% Minimum required total number of tests
constraint
  salinity_tests + ph_tests >= min_total_tests;

% Ratio restriction: pH tests are at most 1.5 times salinity tests
% Integer-safe form: ph_tests <= 1.5 * salinity_tests  <=>  2*ph_tests <= 3*salinity_tests
constraint
  2 * ph_tests <= 3 * salinity_tests;

% Objective
solve minimize total_probes;