% Chemical tests minimization model (all data embedded)

include "globals.mzn";

% Decision variables
var 0..10000: salinity;  % number of salinity tests
var 0..10000: ph;        % number of pH tests

% Constraints
constraint ph >= 250;
constraint salinity + ph >= 400;

% At most 1.5 times more pH tests than salinity tests:
% ph <= 1.5 * salinity  <=>  2*ph <= 3*salinity
constraint 2 * ph <= 3 * salinity;

% Objective: minimize total probes used
% salinity uses 3 probes/test, pH uses 2 probes/test
var 0..100000: probes = 3 * salinity + 2 * ph;

solve minimize probes;

output [
  "Salinity tests = ", show(salinity), "\n",
  "pH tests       = ", show(ph), "\n",
  "Total tests    = ", show(salinity + ph), "\n",
  "Total probes   = ", show(probes), "\n"
];