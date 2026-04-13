% Spare parts allocation to maximize system reliability (product of component reliabilities)
% Data is embedded per problem statement.

include "globals.mzn";

int: nComp = 3;
int: maxSpares = 5;
set of int: COMP = 1..nComp;
set of int: SP = 0..maxSpares;

% Reliability table r[spares, component] as integer per 100 (so 0.5 -> 50)
array[SP, COMP] of int: r100 = array2d(SP, COMP, [
  50, 60, 70,   % 0 spares
  60, 75, 90,   % 1 spare
  70, 95, 100,  % 2 spares
  80, 100, 100, % 3 spares
  90, 100, 100, % 4 spares
  100,100,100   % 5 spares
]);

array[COMP] of int: price = [20, 30, 40];  % yuan per spare
array[COMP] of int: weight = [2, 4, 6];    % kg per spare

int: budgetLimit = 150;
int: weightLimit = 20;

% Decision: number of spares installed for each component
array[COMP] of var SP: spares;

% Induced reliability (per 100) for each component via table lookup
array[COMP] of var 0..100: rel100;
constraint forall(c in COMP)( rel100[c] = r100[spares[c], c] );

% Resource constraints
var 0..10000: totalCost;
var 0..10000: totalWeight;

constraint totalCost = sum(c in COMP)( price[c] * spares[c] );
constraint totalWeight = sum(c in COMP)( weight[c] * spares[c] );

constraint totalCost <= budgetLimit;
constraint totalWeight <= weightLimit;

% Objective: maximize product of reliabilities.
% Use integer product of rel100; maximizing this is equivalent to maximizing true product.
var 0..1000000: sysRelScaled; % up to 100^3
constraint sysRelScaled = rel100[1] * rel100[2] * rel100[3];

solve maximize sysRelScaled;

output [
  "Spares per component = ", show(spares), "\n",
  "Component reliability (%) = ", show(rel100), "\n",
  "Total cost = ", show(totalCost), " (<= ", show(budgetLimit), ")\n",
  "Total weight = ", show(totalWeight), " (<= ", show(weightLimit), ")\n",
  "System reliability (scaled by 100^3) = ", show(sysRelScaled), "\n",
  "System reliability (approx) = ",
    show(float(sysRelScaled) / 1000000.0), "\n"
];