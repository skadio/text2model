include "globals.mzn";

/* Data parameters (to be provided in .dzn file) */
int: M;                          % Number of machines
int: P;                          % Number of parts
array[1..M, 1..P] of int: TimeRequired;  % Time (hours) required on machine m to produce one batch of part p
array[1..M] of int: MachineCosts;          % Cost per hour of operating machine m
array[1..M] of int: Availability;          % Available hours for machine m per month
array[1..P] of int: Prices;                % Selling price for one batch of part p
array[1..P] of int: MinBatches;            % Minimum number of batches required for part p

/* Decision variables: number of batches to produce for each part.
   Must be at least the required minimum. */
array[1..P] of var int: batches;
constraint forall(p in 1..P)( batches[p] >= MinBatches[p] );

/* 
   Production of one batch of part p requires a fixed amount of time 
   on each machine. Typically, for each machine m we would require 
       sum_{p in 1..P} (TimeRequired[m,p] * batches[p]) <= Availability[m].
   However, for machines M-1 and M the machines share their available hours.
   Therefore, for m = M-1 and m = M we impose a combined constraint.
*/

/* For machines that do not share availability: 
   (if M > 2, machines 1 .. M-2 have individual constraints)
   For M==1 or M==2 the sharing does not occur (if M==2 then the two machines form the pair) */
if M > 2 then
  constraint forall(m in 1..M-2)(
    sum(p in 1..P)( TimeRequired[m,p] * batches[p] ) <= Availability[m]
  );
endif;

/* For the shared pair (machines M-1 and M), if available */
if M >= 2 then
  constraint
    sum(p in 1..P)( (TimeRequired[M-1,p] + TimeRequired[M,p]) * batches[p] )
      <= Availability[M-1] + Availability[M];
endif;

/*
   Profit is computed as revenue minus machine operating costs.
   Revenue: sum over parts of (price per batch * number of batches).
   Cost: 
     - For machines m = 1..M-2, cost = MachineCosts[m] * (total processing hours on m).
     - For the shared machines (M-1 and M) the manufacturer can use the cheaper machine 
       (since their availabilities are pooled). Thus the effective cost per hour is the minimum
       of MachineCosts[M-1] and MachineCosts[M].
*/
var int: revenue = sum(p in 1..P)( Prices[p] * batches[p] );

var int: cost_nonshared = if M > 2 then
    sum(m in 1..M-2)( MachineCosts[m] * ( sum(p in 1..P)( TimeRequired[m,p] * batches[p] ) ) )
  else
    0
  endif;

var int: sharedCost = if M >= 2 then
    if MachineCosts[M-1] <= MachineCosts[M] then MachineCosts[M-1] else MachineCosts[M] endif
  else
    0
  endif;

var int: cost_shared = if M >= 2 then
    sharedCost * ( sum(p in 1..P)( (TimeRequired[M-1,p] + TimeRequired[M,p]) * batches[p] ) )
  else
    0
  endif;

var int: profit = revenue - cost_nonshared - cost_shared;

/* Solve the maximization problem */
solve maximize profit;

/* Output: batches produced per part and the overall profit */
output [
  "Batches produced per part: ", show(batches), "\n",
  "Profit: ", show(profit), "\n"
];