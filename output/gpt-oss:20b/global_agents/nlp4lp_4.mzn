%-----------------------------------------------
%  Minimum number of nurses for a weekly night‑shift schedule
%  (consecutive block of x days followed by 7‑x days off)
%-----------------------------------------------

include "globals.mzn";

%--- Input -------------------------------------------------
int: Period;                       % planning period (not used in the model)
array[1..7] of int: Demand;        % required nurses for each day of the week
int: N;                            % upper bound on the number of nurses

%--- Decision variables -----------------------------------
% x[i] : number of consecutive night‑shift days that nurse i works (0..7)
% s[i] : start day of the consecutive block (1..7)
% used[i] : 1 if nurse i is employed, 0 otherwise
% works[i,d] : 1 if nurse i works the night shift on day d
array[1..N] of var 0..7: x;
array[1..N] of var 1..7: s;
array[1..N] of var 0..1: used;
array[1..N, 1..7] of var 0..1: works;

%--- Linking constraints ----------------------------------
% Works corresponds to a consecutive block of length x starting at s
constraint forall(i in 1..N, d in 1..7)(
    works[i,d] = 1 <-> ((d - s[i] + 7) mod 7) < x[i]
);

% A nurse is employed iff she works at least one day
constraint forall(i in 1..N)(
    used[i] = 1 <-> x[i] > 0
);

%--- Demand constraints ------------------------------------
constraint forall(d in 1..7)(
    sum(i in 1..N)(works[i,d]) >= Demand[d]
);

%--- Objective --------------------------------------------
solve minimize sum(i in 1..N)(used[i]);

%--- Output ------------------------------------------------
output [
    "Minimum nurses needed: ", show(sum(i in 1..N)(used[i])), "\n\n",
    "Nurse schedule (i: start day, days worked):\n",
    concat([ show(i) ++ ": s=" ++ show(s[i]) ++ ", x=" ++ show(x[i]) ++ "\n" | i in 1..N]),
    "\nNight shift counts per day:\n",
    concat([ "Day " ++ show(d) ++ ": " ++ show(sum(i in 1..N)(works[i,d])) ++ "\n" | d in 1..7])
];