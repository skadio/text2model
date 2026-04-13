% Vaccine production optimization (embed all data)

include "globals.mzn";

% Data (from problem statement)
int: antibiotics_available = 35000;

int: ab_first  = 30;
int: gel_first = 20;

int: ab_second  = 65;
int: gel_second = 60;

int: min_second = 40;

% Decision variables: number of vaccines to produce
var 0..(antibiotics_available div ab_first): first_dose;
var min_second..(antibiotics_available div ab_second): second_dose;

% Constraints
constraint ab_first * first_dose + ab_second * second_dose <= antibiotics_available;
constraint first_dose > second_dose;   % more first-dose than second-dose
constraint second_dose >= min_second;

% Objective: minimize gelatine used
var int: total_gel = gel_first * first_dose + gel_second * second_dose;
solve minimize total_gel;

output [
  "First-dose vaccines = ", show(first_dose), "\n",
  "Second-dose vaccines = ", show(second_dose), "\n",
  "Total gelatine used (mg) = ", show(total_gel), "\n",
  "Antibiotics used (units) = ", show(ab_first * first_dose + ab_second * second_dose), "\n"
];