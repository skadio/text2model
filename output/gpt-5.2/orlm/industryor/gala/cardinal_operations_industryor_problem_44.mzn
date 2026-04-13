include "globals.mzn";

% Factory production planning with piecewise (bulk-discount) profit per unit.
% All data embedded from the statement.

% Decision variables: quantities to produce (integer pieces)
var 0..1000: xA;
var 0..1000: xB;
var 0..1000: xC;

% Resource limits
int: tech_cap = 100;
int: labor_cap = 700;
int: mat_cap  = 400;

% Resource consumption per unit
int: techA = 1; int: laborA = 10; int: matA = 3;
int: techB = 2; int: laborB = 4;  int: matB = 2;
int: techC = 1; int: laborC = 5;  int: matC = 1;

constraint techA*xA + techB*xB + techC*xC <= tech_cap;
constraint laborA*xA + laborB*xB + laborC*xC <= labor_cap;
constraint matA*xA + matB*xB + matC*xC <= mat_cap;

% Piecewise profit functions (profit per unit depends on sales volume bracket)
% Product A: 0..40 ->10, 41..100 ->9, 101..150 ->8, >=151 ->7
var int: profitA =
    if xA <= 40 then 10*xA
    elseif xA <= 100 then 9*xA
    elseif xA <= 150 then 8*xA
    else 7*xA endif;

% Product B: 0..50 ->6, 51..100 ->4, >=101 ->3
var int: profitB =
    if xB <= 50 then 6*xB
    elseif xB <= 100 then 4*xB
    else 3*xB endif;

% Product C: 0..100 ->5, >=101 ->4
var int: profitC =
    if xC <= 100 then 5*xC
    else 4*xC endif;

var int: total_profit = profitA + profitB + profitC;

solve maximize total_profit;

output [
  "xA = ", show(xA), "\n",
  "xB = ", show(xB), "\n",
  "xC = ", show(xC), "\n",
  "profitA = ", show(profitA), "\n",
  "profitB = ", show(profitB), "\n",
  "profitC = ", show(profitC), "\n",
  "total_profit = ", show(total_profit), "\n",
  "tech_used = ", show(techA*xA + techB*xB + techC*xC), " / ", show(tech_cap), "\n",
  "labor_used = ", show(laborA*xA + laborB*xB + laborC*xC), " / ", show(labor_cap), "\n",
  "mat_used = ", show(matA*xA + matB*xB + matC*xC), " / ", show(mat_cap), "\n"
];