include "globals.mzn";

/* ------------------------------------------------------------------
   Data
   ------------------------------------------------------------------ */
int: n;                           % number of days in the recurring period
array[0..n-1] of int: demand;    % required employees per day

int: full_time_pay;              % pay per day of a full‑time employee
int: part_time_pay;              % pay per day of a part‑time employee

int: full_time_shift;            % consecutive work days of a full‑time worker
int: part_time_shift;            % consecutive work days of a part‑time worker

/* ------------------------------------------------------------------
   Derived constants
   ------------------------------------------------------------------ */
int: total_demand = sum(d in 0..n-1) demand[d];   % upper bound on any worker count

/* ------------------------------------------------------------------
   Decision variables
   ------------------------------------------------------------------ */
/* number of full‑time workers that start a work block on day i */
array[0..n-1] of var 0..total_demand: ft_start;

/* number of part‑time workers that start a work block on day i */
array[0..n-1] of var 0..total_demand: pt_start;

/* ------------------------------------------------------------------
   Constraints
   ------------------------------------------------------------------ */
/* For each day d, the number of workers on duty must meet the demand. */
constraint forall(d in 0..n-1) (
    /* full‑time workers on day d */
    sum(s in 0..n-1 where ( (d - s + n) mod n ) < full_time_shift) ft_start[s]
    +
    /* part‑time workers on day d */
    sum(p in 0..n-1 where ( (d - p + n) mod n ) < part_time_shift) pt_start[p]
    >= demand[d]
);

/* ------------------------------------------------------------------
   Objective
   ------------------------------------------------------------------ */
var int: total_cost = 
    sum(s in 0..n-1) ft_start[s] * full_time_pay * full_time_shift
  + sum(p in 0..n-1) pt_start[p] * part_time_pay * part_time_shift;

solve minimize total_cost;

/* ------------------------------------------------------------------
   Output
   ------------------------------------------------------------------ */
output [
    "Total cost = ", show(total_cost), "\n",
    "Full‑time start counts = ", show(ft_start), "\n",
    "Part‑time start counts = ", show(pt_start), "\n"
];