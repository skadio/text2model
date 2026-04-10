% Parameters
int: probes_per_salinity = 3;          % Probes required per salinity test
int: probes_per_ph = 2;                % Probes required per pH test
int: min_ph_tests = 250;               % Minimum number of pH tests
int: min_total_tests = 400;            % Minimum total number of tests
float: max_ph_to_salinity_ratio = 1.5; % At most 1.5 times more pH than salinity (kept for documentation)

% Variables
var 0..100000: salinity_tests;         % Number of salinity tests performed
var 0..100000: ph_tests;               % Number of pH tests performed
var 0..1000000: total_probes;          % Total probes used (objective helper)

% Constraints
% --- Minimum test requirements ---
constraint ph_tests >= min_ph_tests; % At least the minimum number of pH tests
constraint salinity_tests + ph_tests >= min_total_tests; % At least the minimum total number of tests

% --- Ratio constraint (pH not more than 1.5 times salinity) ---
% Avoid float arithmetic: ph_tests <= 1.5 * salinity_tests  <=>  2*ph_tests <= 3*salinity_tests
constraint 2 * ph_tests <= 3 * salinity_tests;

% --- Total probes accounting ---
constraint total_probes = probes_per_salinity * salinity_tests + probes_per_ph * ph_tests;

% Objective
solve minimize total_probes;