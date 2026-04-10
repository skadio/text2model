% Swab scheduling optimization (all data embedded)

int: throat_time = 5;
int: nasal_time  = 3;
int: total_time  = 20000;

int: min_nasal = 30;
int: throat_to_nasal_ratio = 4; % throat >= 4 * nasal

var 0..total_time div throat_time: throat;
var 0..total_time div nasal_time: nasal;

constraint nasal >= min_nasal;
constraint throat >= throat_to_nasal_ratio * nasal;
constraint throat_time * throat + nasal_time * nasal <= total_time;

var int: patients = throat + nasal;

solve maximize patients;

output [
  "throat = ", show(throat), "\n",
  "nasal = ", show(nasal), "\n",
  "patients = ", show(patients), "\n",
  "time_used = ", show(throat_time*throat + nasal_time*nasal), "\n"
];