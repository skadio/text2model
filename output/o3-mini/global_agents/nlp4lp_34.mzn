include "globals.mzn";

/*---------- Parameters (provided in the .dzn file) ----------*/
int: T;                          % Total number of periods in a day
int: K;                          % Total number of generator types

array[1..T] of int: Demand;      % Demand in each period t

array[1..K] of int: NumGenerator; % Number of generators available for each type k
array[1..K] of int: MinLevel;      % Minimum production level for each generator type k
array[1..K] of int: MaxLevel;      % Maximum production level for each generator type k

array[1..K] of int: RunCost;       % Running cost per period at minimum level for type k
array[1..K] of float: ExtraCost;   % Extra cost per MW produced above the minimum for type k
array[1..K] of int: StartCost;     % Start-up cost for type k

/*---------- Decision Variables ----------*/
/* working[t,k]: number of generators of type k that are on during period t 
   Domain: 0 to the available number of that generator type. */
array[1..T, 1..K] of var int: working;

/* prod[t,k]: total production (in MW) by generators of type k in period t.
   Production constraints will force prod[t,k] = 0 when working[t,k] = 0 and, when working > 0,
   prod[t,k] is between working[t,k]*MinLevel[k] and working[t,k]*MaxLevel[k]. */
array[1..T, 1..K] of var int: prod;

/* startup[t,k]: number of generators of type k started up in period t.
   For period 1, startup equals working (since we assume all generators start off).
   For t > 1, startup[t,k] is the increase in working generators compared to the previous period. */
array[1..T, 1..K] of var int: startup;


/*---------- Constraints ----------*/

/* Bound the number of working generators in each period by the available number */
constraint
  forall(t in 1..T, k in 1..K) (
    working[t,k] >= 0 /\ working[t,k] <= NumGenerator[k]
  );

/* Production limits: if some generators of a type are working, their total production
   must be at least working[t,k]*MinLevel[k] and at most working[t,k]*MaxLevel[k].
   (When working[t,k] = 0, these force prod[t,k] = 0.) */
constraint
  forall(t in 1..T, k in 1..K) (
    prod[t,k] >= working[t,k] * MinLevel[k] /\
    prod[t,k] <= working[t,k] * MaxLevel[k]
  );

/* Demand must be met exactly in each period */
constraint
  forall(t in 1..T) (
    sum(k in 1..K)( prod[t,k] ) = Demand[t]
  );

/* Startup definition:
   - For period 1, all working generators are considered to have started up.
   - For t > 1, only the increase in working generators (if any) counts as startup.
*/
constraint
  forall(k in 1..K) (
    startup[1,k] = working[1,k]
  );

constraint
  forall(t in 2..T, k in 1..K) (
    startup[t,k] = if working[t,k] > working[t-1,k] then working[t,k] - working[t-1,k] else 0 endif
  );

/*---------- Objective Function ----------*/
/* For each generator type operating in a period, the cost consists of:
   - A fixed running cost per generator operating at minimum level.
   - An extra cost for every MW produced above the minimum level.
   - A start-up cost for every generator that is started in that period.
   
   Hence, the period t, type k cost is:
     working[t,k]*RunCost[k] +
     (prod[t,k] - working[t,k]*MinLevel[k]) * ExtraCost[k] +
     startup[t,k]*StartCost[k]
*/
var float: total_cost = sum(t in 1..T, k in 1..K)(
    working[t,k] * RunCost[k]
  + (prod[t,k] - working[t,k] * MinLevel[k]) * ExtraCost[k]
  + startup[t,k] * StartCost[k]
);

/*---------- Solve Item ----------*/
solve minimize total_cost;

/*---------- Output ----------*/
output [
  "Total Cost = ", show(total_cost), "\n",
  "Working Generators per period and type:\n", show(working), "\n",
  "Production per period and type:\n", show(prod), "\n",
  "Startup per period and type:\n", show(startup), "\n"
];