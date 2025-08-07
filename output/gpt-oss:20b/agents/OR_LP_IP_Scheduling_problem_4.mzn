include "globals.mzn";

%--- data --------------------------------------------------------------
int: n;                                  % grid size (rows & columns)
array[1..n, 1..n] of int: huts;          % 1 = villager, 0 = empty

%--- decision variables ------------------------------------------------
% Coordinates of the two airdrop locations
var 1..n: d1x, d1y;
var 1..n: d2x, d2y;
constraint (d1x, d1y) != (d2x, d2y);     % they must be different

% Distances from every grid cell to each drop
array[1..n, 1..n] of var int: dist1, dist2, dmin;
constraint
    forall(i in 1..n, j in 1..n)(
        dist1[i,j] = (i - d1x)*(i - d1x) + (j - d1y)*(j - d1y)
        /\ dist2[i,j] = (i - d2x)*(i - d2x) + (j - d2y)*(j - d2y)
        /\ dmin[i,j] = min([dist1[i,j], dist2[i,j]])
    );

%--- objective ---------------------------------------------------------
var int: total;
constraint total = sum([ dmin[i,j] | i in 1..n, j in 1..n
                         where huts[i,j] == 1 ]);

solve minimize total;

%--- output ------------------------------------------------------------
output [
  "Drop 1 at (", show(d1x), ",", show(d1y), ")\n",
  "Drop 2 at (", show(d2x), ",", show(d2y), ")\n",
  "Total squared distance = ", show(total), "\n"
];