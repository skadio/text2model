include "globals.mzn";

% Greenhouse gases: CO2, CH4, N2O, CFC
set of int: G = 1..4;
int: CO2 = 1;
int: CH4 = 2;
int: N2O = 3;
int: CFC = 4;

% Global warming potentials (units per tonne)
array[G] of int: gwp = [4, 3, 5, 7];

% Decision variables: emission levels (tonnes), whole numbers
% Upper bound can be safely limited by total emissions constraint (<=1500).
array[G] of var 0..1500: e;

% Constraints
constraint e[CO2] + e[CH4] - 2*e[N2O] - 2*e[CFC] <= 1000;
constraint 3*e[CO2] - e[CH4] + e[N2O] <= 800;
constraint e[CO2] - e[CH4] - e[N2O] >= 200;
constraint sum(g in G)(e[g]) <= 1500;

% Objective: minimize total global warming potential
var 0..(1500 * 7): total_gwp = sum(g in G)(gwp[g] * e[g]);

solve minimize total_gwp;

output [
  "Minimum total GWP = ", show(total_gwp), "\n",
  "Emissions (tonnes):\n",
  "  CO2 = ", show(e[CO2]), "\n",
  "  CH4 = ", show(e[CH4]), "\n",
  "  N2O = ", show(e[N2O]), "\n",
  "  CFC = ", show(e[CFC]), "\n"
];