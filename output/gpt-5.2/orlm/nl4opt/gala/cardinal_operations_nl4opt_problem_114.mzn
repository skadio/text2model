include "globals.mzn";

% Data (embedded from problem statement)
int: time_throat = 5;      % minutes per throat swab
int: time_nasal  = 3;      % minutes per nasal swab
int: min_nasal   = 30;     % at least this many nasal swabs
int: total_time  = 20000;  % total operational minutes

% Decision variables
var 0..total_time div time_throat: throat;
var min_nasal..total_time div time_nasal: nasal;

% Constraints
constraint time_throat * throat + time_nasal * nasal <= total_time;
constraint throat >= 4 * nasal;

% Objective: maximize number of patients seen (= total swabs)
var 0..(total_time div min(time_throat, time_nasal)): total_patients;
constraint total_patients = throat + nasal;

solve maximize total_patients;

output [
  "throat = ", show(throat), "\n",
  "nasal = ", show(nasal), "\n",
  "total_patients = ", show(total_patients), "\n",
  "total_time_used = ", show(time_throat*throat + time_nasal*nasal), "\n"
];