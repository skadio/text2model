% Greenhouse gas emissions minimization (all data embedded)

set of int: G = 1..4;
int: CO2 = 1;
int: CH4 = 2;
int: N2O = 3;
int: CFC = 4;

array[G] of int: gwp = [4, 3, 5, 7]; % global warming potential units per tonne

int: MAX_TOTAL = 1500;

% Decision variables: emissions in tonnes (integers)
array[G] of var 0..MAX_TOTAL: x;

% Constraints
constraint x[CO2] + x[CH4] - 2 * x[N2O] - 2 * x[CFC] <= 1000;
constraint 3 * x[CO2] - x[CH4] + x[N2O] <= 800;
constraint x[CO2] - x[CH4] - x[N2O] >= 200;
constraint sum(g in G)(x[g]) <= 1500;

% Objective: minimize total global warming potential
var int: total_gwp = sum(g in G)(gwp[g] * x[g]);
solve minimize total_gwp;

output [
  "Minimum total global warming potential = ", show(total_gwp), "\n",
  "CO2 = ", show(x[CO2]), " tonnes\n",
  "CH4 = ", show(x[CH4]), " tonnes\n",
  "N2O = ", show(x[N2O]), " tonnes\n",
  "CFC = ", show(x[CFC]), " tonnes\n"
];