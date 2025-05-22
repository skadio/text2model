% Parameters
int: n;
array[1..n, 1..n] of int: huts;

set of int: GRID = 1..n;

% Variables
array[1..2] of var 1..n: r;   % Row indices of the two airdrop locations
array[1..2] of var 1..n: c;   % Column indices of the two airdrop locations

% Constraints
constraint
    (r[1] != r[2]) \/ (c[1] != c[2]);        % The two airdrop locations must be different

% Objective
var int: totalDistance =
    sum(i in GRID, j in GRID)(
        huts[i,j] *
        min( (i - r[1])*(i - r[1]) + (j - c[1])*(j - c[1]),
             (i - r[2])*(i - r[2]) + (j - c[2])*(j - c[2]) )
    );

solve minimize totalDistance;