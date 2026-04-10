include "globals.mzn";

% Data parameters
int: n;
array[1..n,1..n] of int: huts;   % each cell holds the number of villagers

% Decision: choose exactly 2 distinct airdrop locations (flat indices for grid cells)
int: numDrops = 2;
array[1..numDrops] of var 1..(n*n): dropLocations;
constraint all_different(dropLocations);

% Compute the total cost as the sum over all grid cells of:
%   [number of villagers in cell] * [squared Euclidean distance to the nearest drop]
%
% For a cell at position (i,j) and a drop at flat index d,
%       row_d = ((d-1) div n) + 1
%       col_d = ((d-1) mod n) + 1
%
% Squared distance = (i - row_d)^2 + (j - col_d)^2.
% We take the minimum distance among the two drops for each cell.

var int: totalCost = 
  sum(i in 1..n, j in 1..n) (
    huts[i,j] *
    let {
      var int: d1 = (i - (((dropLocations[1]-1) div n) + 1))^2 
                    + (j - (((dropLocations[1]-1) mod n) + 1))^2,
      var int: d2 = (i - (((dropLocations[2]-1) div n) + 1))^2 
                    + (j - (((dropLocations[2]-1) mod n) + 1))^2
    } in if d1 <= d2 then d1 else d2 endif
  );

solve minimize totalCost;

output [
  "Drop Locations (flat indices) = ", show(dropLocations), "\n",
  "Total cost = ", show(totalCost)
];