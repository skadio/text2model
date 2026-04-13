% Chemical tests optimization: minimize total probes used

var 0..100000: salinity; % number of salinity tests
var 0..100000: ph;       % number of pH tests

% Constraints
constraint ph >= 250;
constraint salinity + ph >= 400;
constraint ph <= 1.5 * salinity;

% Objective: minimize total probes
var int: total_probes = 3 * salinity + 2 * ph;
solve minimize total_probes;

output [
  "salinity_tests = ", show(salinity), "\n",
  "ph_tests = ", show(ph), "\n",
  "total_tests = ", show(salinity + ph), "\n",
  "total_probes = ", show(total_probes), "\n"
];