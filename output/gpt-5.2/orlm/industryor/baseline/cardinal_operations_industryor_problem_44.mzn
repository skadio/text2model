% Production planning with bulk-discount (piecewise constant unit profit)
% All data embedded.

int: TechAvail = 100;
int: LaborAvail = 700;
int: MatAvail = 400;

% Resource requirements per unit for products A,B,C (in order)
array[1..3] of int: tech = [1, 2, 1];
array[1..3] of int: labor = [10, 4, 5];
array[1..3] of int: mat = [3, 2, 1];

% Decision variables: production quantities
var 0..1000: xA;
var 0..1000: xB;
var 0..1000: xC;

% Resource constraints
constraint tech[1]*xA + tech[2]*xB + tech[3]*xC <= TechAvail;
constraint labor[1]*xA + labor[2]*xB + labor[3]*xC <= LaborAvail;
constraint mat[1]*xA + mat[2]*xB + mat[3]*xC <= MatAvail;

% Piecewise unit-profit selection via segment variables
% Each product uses exactly one segment; quantity must lie in that segment.

% --- Product A segments:
% 0..40 => 10, 41..100 => 9, 101..150 => 8, 151..(cap) => 7
% Cap can be derived from resources; use a safe upper bound:
int: capA = min(TechAvail div tech[1], min(LaborAvail div labor[1], MatAvail div mat[1])); % <= 70
array[1..4] of int: loA = [0, 41, 101, 151];
array[1..4] of int: hiA = [40, 100, 150, capA];
array[1..4] of int: pA  = [10, 9, 8, 7];
array[1..4] of var bool: segA;
constraint sum(segA) = 1;
constraint forall(s in 1..4)(
  segA[s] -> (xA >= loA[s] /\ xA <= hiA[s])
);

% --- Product B segments:
% 0..50 => 6, 51..100 => 4, 101..(cap) => 3
int: capB = min(TechAvail div tech[2], min(LaborAvail div labor[2], MatAvail div mat[2])); % <= 50
array[1..3] of int: loB = [0, 51, 101];
array[1..3] of int: hiB = [50, 100, capB];
array[1..3] of int: pB  = [6, 4, 3];
array[1..3] of var bool: segB;
constraint sum(segB) = 1;
constraint forall(s in 1..3)(
  segB[s] -> (xB >= loB[s] /\ xB <= hiB[s])
);

% --- Product C segments:
% 0..100 => 5, 101..(cap) => 4
int: capC = min(TechAvail div tech[3], min(LaborAvail div labor[3], MatAvail div mat[3])); % <= 100
array[1..2] of int: loC = [0, 101];
array[1..2] of int: hiC = [100, capC];
array[1..2] of int: pC  = [5, 4];
array[1..2] of var bool: segC;
constraint sum(segC) = 1;
constraint forall(s in 1..2)(
  segC[s] -> (xC >= loC[s] /\ xC <= hiC[s])
);

% Objective: maximize total profit (unit profit depends on chosen segment)
var int: profit =
    xA * sum(s in 1..4)(pA[s] * bool2int(segA[s]))
  + xB * sum(s in 1..3)(pB[s] * bool2int(segB[s]))
  + xC * sum(s in 1..2)(pC[s] * bool2int(segC[s]));

solve maximize profit;

output [
  "xA=", show(xA), "  xB=", show(xB), "  xC=", show(xC), "\n",
  "profit=", show(profit), "\n",
  "A segment=", show([bool2int(segA[s]) | s in 1..4]), " (unit profits ", show(pA), ")\n",
  "B segment=", show([bool2int(segB[s]) | s in 1..3]), " (unit profits ", show(pB), ")\n",
  "C segment=", show([bool2int(segC[s]) | s in 1..2]), " (unit profits ", show(pC), ")\n"
];