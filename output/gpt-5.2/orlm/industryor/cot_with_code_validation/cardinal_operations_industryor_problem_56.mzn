% Paper roll cutting to minimize waste area
% Data embedded from problem statement

int: nOrders = 3;
set of int: ORD = 1..nOrders;

array[ORD] of float: width_req = [0.5, 0.7, 0.9];
array[ORD] of int:   length_req = [1000, 3000, 2000];

int: nRollTypes = 2;
set of int: RT = 1..nRollTypes;
array[RT] of float: roll_width = [1.0, 2.0];

% Pre-enumerated feasible cutting patterns (counts of strips per order width)
% Patterns for 1.0m roll (a,b,c) such that 0.5a + 0.7b + 0.9c <= 1.0
int: nPatterns1 = 14;
set of int: P1 = 1..nPatterns1;

array[P1, ORD] of int: pat1 =
array2d(P1, ORD,
[
  0,0,0,
  1,0,0,
  2,0,0,
  0,1,0,
  1,1,0,
  0,0,1,
  1,0,1,
  0,1,1,
  2,0,1,
  3,0,0,
  0,0,2,
  1,0,2,
  0,2,0,
  2,1,0
]);

% Patterns for 2.0m roll (a,b,c) such that 0.5a + 0.7b + 0.9c <= 2.0
int: nPatterns2 = 43;
set of int: P2 = 1..nPatterns2;

array[P2, ORD] of int: pat2 =
array2d(P2, ORD,
[
  0,0,0,
  1,0,0,
  2,0,0,
  3,0,0,
  4,0,0,
  0,1,0,
  1,1,0,
  2,1,0,
  3,1,0,
  0,2,0,
  1,2,0,
  2,2,0,
  0,3,0,
  1,3,0,
  0,0,1,
  1,0,1,
  2,0,1,
  3,0,1,
  0,1,1,
  1,1,1,
  2,1,1,
  0,2,1,
  1,2,1,
  0,0,2,
  1,0,2,
  2,0,2,
  0,1,2,
  1,1,2,
  0,0,3,
  1,0,3,
  0,0,4,
  0,0,5,
  0,0,6,
  0,0,7,
  0,0,8,
  0,0,9,
  0,0,10,
  0,0,11,
  0,0,12,
  0,0,13,
  0,0,14,
  0,0,15,
  0,0,16
]);

int: total_length = sum(o in ORD)(length_req[o]);
int: maxLen = total_length;

% Decision variables: length (meters) assigned to each pattern
array[P1] of var 0..maxLen: L1;
array[P2] of var 0..maxLen: L2;

% Produced length per order (meters of that width)
array[ORD] of var 0..maxLen: prodLen;

constraint
  forall(o in ORD)(
    prodLen[o] =
      sum(p in P1)(L1[p] * pat1[p,o]) +
      sum(p in P2)(L2[p] * pat2[p,o])
  );

constraint forall(o in ORD)(prodLen[o] >= length_req[o]);

% Objective: minimize waste area = used roll area - demanded area
var float: usedArea =
  roll_width[1] * int2float(sum(p in P1)(L1[p])) +
  roll_width[2] * int2float(sum(p in P2)(L2[p]));

float: demandArea =
  sum(o in ORD)(width_req[o] * int2float(length_req[o]));

var float: wasteArea = usedArea - demandArea;

solve minimize wasteArea;

output [
  "wasteArea=", show(wasteArea), "\n",
  "usedArea=", show(usedArea), "\n",
  "demandArea=", show(demandArea), "\n",
  "L1=", show(L1), "\n",
  "L2=", show(L2), "\n",
  "prodLen=", show(prodLen), "\n"
];