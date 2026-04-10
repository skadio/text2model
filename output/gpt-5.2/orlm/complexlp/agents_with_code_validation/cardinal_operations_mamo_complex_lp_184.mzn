% China Railroad freight car relocation - least cost flow

int: nRegions = 5;
set of int: R = 1..nRegions;

array[R] of int: present = [120, 330, 400, 400, 600];
array[R] of int: needed  = [150, 200, 600, 200, 400];

% Full symmetric cost matrix (0 on diagonal)
array[R, R] of int: cost = array2d(R, R, [
  0, 11, 11, 13, 28,
  11, 0, 18,  8, 46,
  11, 18, 0,  9, 27,
  13,  8, 9,  0, 20,
  28, 46, 27, 20, 0
]);

% Total surplus provides a safe upper bound for any single shipment
int: totalSurplus = sum(r in R)(if present[r] > needed[r] then present[r] - needed[r] else 0 endif);

array[R, R] of var 0..totalSurplus: x;  % x[i,j] cars moved from i to j (including i=j, constrained to 0)

constraint forall(r in R) (x[r,r] = 0);

% Flow balance: outflow - inflow = present - needed
constraint
  forall(r in R) (
    sum(j in R)(x[r,j]) - sum(i in R)(x[i,r]) = present[r] - needed[r]
  );

var int: totalCost = sum(i in R, j in R)(cost[i,j] * x[i,j]);

solve minimize totalCost;

output ["totalCost = ", show(totalCost), "\n"];