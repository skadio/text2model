include "globals.mzn";

% Data (embedded from problem statement)
set of int: S = 1..4;
int: COAL  = 1;
int: GAS   = 2;
int: WIND  = 3;
int: SOLAR = 4;

array[S] of int: maxGen = [700, 600, 300, 250];

% Costs in cents per unit to keep everything integral
array[S] of int: costCents = [80, 120, 100, 150];

int: minCoalGas = 500;
int: minWindSolar = 200;

% Decision variables: whole units generated from each source
array[S] of var 0..maxGen[s]: gen;

% Constraints
constraint gen[COAL] + gen[GAS] >= minCoalGas;
constraint gen[WIND] + gen[SOLAR] >= minWindSolar;

% Objective: minimize total cost in cents
var int: totalCostCents = sum(s in S)(costCents[s] * gen[s]);
solve minimize totalCostCents;

% Output: dollars rounded to nearest whole dollar
output [
  "Coal = ", show(gen[COAL]), " units\n",
  "Gas = ", show(gen[GAS]), " units\n",
  "Wind = ", show(gen[WIND]), " units\n",
  "Solar = ", show(gen[SOLAR]), " units\n",
  "Total cost (rounded $) = ",
  show((totalCostCents + 50) div 100), "\n"
];