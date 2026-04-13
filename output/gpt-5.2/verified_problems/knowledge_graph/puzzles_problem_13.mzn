include "globals.mzn";

int: r;
int: c;
array[1..r, 1..c] of int: puzzle; % 0 = empty, >0 = given

set of int: R = 1..r;
set of int: C = 1..c;

int: startNumber = min([puzzle[i,j] | i in R, j in C where puzzle[i,j] > 0]);
int: endNumber   = max([puzzle[i,j] | i in R, j in C where puzzle[i,j] > 0]);

% Decision variables: value in each cell
array[R, C] of var 0..endNumber: x;

% Fixed clues
constraint forall(i in R, j in C where puzzle[i,j] > 0) (x[i,j] = puzzle[i,j]);

% Each number 1..endNumber appears exactly once in the grid
constraint
  forall(v in 1..endNumber) (
    sum(i in R, j in C)(bool2int(x[i,j] = v)) = 1
  );

% No other positive numbers besides 1..endNumber
constraint forall(i in R, j in C) (x[i,j] > 0);

% Helper: adjacency check for two cells
function var bool: adjacent(var int: i1, var int: j1, var int: i2, var int: j2) =
  abs(i1 - i2) <= 1 /\ abs(j1 - j2) <= 1 /\ (i1 != i2 \/ j1 != j2);

% Position of each value v
array[1..endNumber] of var R: pos_r;
array[1..endNumber] of var C: pos_c;

% Link positions to grid values
constraint forall(v in 1..endNumber)(
  sum(i in R, j in C)(bool2int(x[i,j] = v) * i) = pos_r[v] /\
  sum(i in R, j in C)(bool2int(x[i,j] = v) * j) = pos_c[v]
);

% Consecutive numbers must be adjacent (8-neighborhood)
constraint forall(v in 1..endNumber-1)(
  adjacent(pos_r[v], pos_c[v], pos_r[v+1], pos_c[v+1])
);

solve satisfy;

output [
  "startNumber=", show(startNumber), " endNumber=", show(endNumber), "\n",
  "grid:\n"
] ++
[
  if j = 1 then "" else " " endif ++
  show(x[i,j])
  ++ if j = c then "\n" else "" endif
  | i in R, j in C
];