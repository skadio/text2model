include "globals.mzn";

/* Data (from .dzn file) */
int: N;                     % number of days in the recurring period
array[1..N] of int: Num;    % required number of employees on each day
int: WorkingDays;           % consecutive working days per employee
int: RestingDays;           % consecutive resting days per employee

/* Derived constants */
int: L = WorkingDays + RestingDays;                 % cycle length
int: maxM = sum(Num);                               % upper bound on employees

/* Decision variables: number of employees whose working block
   starts at offset s (1 .. L) */
array[1..L] of var 0..maxM: x;

/* Constraints: for each day d, the total number of employees working
   must equal Num[d] */
constraint
  forall(d in 1..N) (
    sum(s in 1..L) (
      x[s] * bool2int( ((d - s) mod L) < WorkingDays )
    ) == Num[d]
  );

/* Objective: minimize total number of employees */
solve minimize sum(x);

/* Output */
output [
  "Minimum number of employees: ", show(sum(x)), "\n",
  "Employees per start offset (1..", show(L), "): ", show(x), "\n"
];