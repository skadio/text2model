include "globals.mzn";

%----------------------------
% Input data
%----------------------------
int: n;                                    % number of days in the cycle
array[0..n-1] of int: demand;              % required workers each day (0-based)
int: full_time_pay;                        % pay per day
int: part_time_pay;                        % pay per day
int: full_time_shift;                      % consecutive work days
int: part_time_shift;                      % consecutive work days

%----------------------------
% Decision variables
%----------------------------
% xF[d] = number of full-time workers whose shift starts on day d
% xP[d] = number of part-time workers whose shift starts on day d
array[0..n-1] of var 0..max(demand): xF;
array[0..n-1] of var 0..max(demand): xP;

%----------------------------
% Helper: whether a worker starting at s works on day d (cyclic)
% A worker works for L consecutive days starting at s (mod n),
% then has (n-L) days off, repeating each cycle.
%----------------------------
function bool: works(int: s, int: d, int: L) =
  ((d - s + n) mod n) < L;

%----------------------------
% Coverage constraints
%----------------------------
constraint
  forall(d in 0..n-1) (
    sum(s in 0..n-1 where works(s,d,full_time_shift)) (xF[s]) +
    sum(s in 0..n-1 where works(s,d,part_time_shift)) (xP[s])
    >= demand[d]
  );

%----------------------------
% Objective: minimize staffing cost per cycle
% Each worker is paid per day worked.
%----------------------------
var int: total_cost =
    full_time_pay * full_time_shift * sum(s in 0..n-1)(xF[s])
  + part_time_pay * part_time_shift * sum(s in 0..n-1)(xP[s]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "xF (full-time starts) = ", show(xF), "\n",
  "xP (part-time starts) = ", show(xP), "\n"
];