include "globals.mzn";

%----------------------------
% Data (embedded)
%----------------------------
int: nParts = 10;
set of int: PART = 1..nParts;

set of int: MACH = 1..3;           % 1=A, 2=B, 3=C
int: A = 1;
int: B = 2;
int: C = 3;

array[MACH] of int: setup = [100, 135, 200];

% unit processing costs cost[machine, part]
array[MACH, PART] of int: cost =
[
  % parts:  1   2   3   4   5   6   7   8   9   10
            10, 20, 30, 40, 50, 60, 70, 80, 90, 100,   % A
            15, 25, 35, 45, 55, 65, 75, 85, 95, 105,   % B
            20, 30, 40, 50, 60, 70, 80, 90, 100, 110   % C
];

%----------------------------
% Decision variables
%----------------------------
array[PART] of var MACH: mach;         % machine assignment for each part

array[MACH] of var 0..1: used;         % used[m]=1 iff any part assigned to machine m

%----------------------------
% Constraints
%----------------------------

% (2) Coupling between part 1 and part 2
constraint (mach[1] = A) <-> (mach[2] != A);  % if 1 on A then 2 on B/C; else 2 on A

% (3) Fixed assignments
constraint mach[3] = A;
constraint mach[4] = B;
constraint mach[5] = C;

% (4) At most 3 parts on machine C
var 0..nParts: nOnC;
constraint count(mach, C, nOnC);
constraint nOnC <= 3;

% Link used[m] to whether machine m is selected by any part
constraint forall(m in MACH)(
  used[m] = bool2int(exists(p in PART)(mach[p] = m))
);

%----------------------------
% Objective: minimize total processing + setup costs
%----------------------------
var int: total_processing = sum(p in PART)( cost[mach[p], p] );
var int: total_setup      = sum(m in MACH)( setup[m] * used[m] );
var int: total_cost       = total_processing + total_setup;

solve minimize total_cost;

%----------------------------
% Output
%----------------------------
output [
  "mach = ", show(mach), "\n",
  "used = ", show(used), "\n",
  "nOnC = ", show(nOnC), "\n",
  "total_processing = ", show(total_processing), "\n",
  "total_setup = ", show(total_setup), "\n",
  "total_cost = ", show(total_cost), "\n"
];