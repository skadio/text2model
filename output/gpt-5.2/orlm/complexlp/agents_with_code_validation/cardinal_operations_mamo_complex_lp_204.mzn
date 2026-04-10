% Fertilizer blending with tight composition bounds (LP as MIP via fixed scale)

int: nF = 5;
set of int: F = 1..nF;

array[F] of int: Ni = [10, 8, 12, 10, 15];   % Nitrogen %
array[F] of int: Ph = [8, 11, 7, 10, 10];    % Phosphorus %
array[F] of int: Po = [12, 15, 12, 10, 6];   % Potash %

% Costs in cents per 100 pounds
array[F] of int: costPer100 = [2175, 2350, 2200, 1950, 1850];

int: targetNi = 10;
int: targetPh = 8;
int: targetPo = 12;

% Use 0.5% tolerance => upper bound is target + 0.5 = target + 1/2
int: tolNum = 1;
int: tolDen = 2;

% Reduce scale to make solving fast; 2000 gives 0.05% resolution
int: scale = 2000;

% Decision variables: parts of each fertilizer, sum to scale
array[F] of var 0..scale: x;

var int: sumNi = sum(i in F)(Ni[i] * x[i]);
var int: sumPh = sum(i in F)(Ph[i] * x[i]);
var int: sumPo = sum(i in F)(Po[i] * x[i]);

var int: totalCostCentsPer100Parts = sum(i in F)(costPer100[i] * x[i]);

constraint sum(i in F)(x[i]) = scale;

% Composition constraints:
% target <= sumChem/scale <= target + 0.5
% Upper: sumChem/scale <= target + 1/2  <=>  2*sumChem <= (2*target+1)*scale
constraint targetNi * scale <= sumNi;
constraint tolDen * sumNi <= (tolDen * targetNi + tolNum) * scale;

constraint targetPh * scale <= sumPh;
constraint tolDen * sumPh <= (tolDen * targetPh + tolNum) * scale;

constraint targetPo * scale <= sumPo;
constraint tolDen * sumPo <= (tolDen * targetPo + tolNum) * scale;

solve minimize totalCostCentsPer100Parts;

output [
  "x(parts) = ", show(x), "\n",
  "cost (cents per 100lb, scaled) = ", show(totalCostCentsPer100Parts), "\n"
];