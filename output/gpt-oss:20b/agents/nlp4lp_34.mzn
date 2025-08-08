include "globals.mzn";

/* Data – provided in the .dzn file */
int: T;                                % number of periods
int: K;                                % number of generator types
array[1..T] of int: Demand;            % demand in each period
array[1..K] of int: NumGenerator;      % number of units of each type
array[1..K] of int: MinLevel;          % min output of a unit of type k
array[1..K] of int: MaxLevel;          % max output of a unit of type k
array[1..K] of int: RunCost;           % running cost of a unit of type k
array[1..K] of float: ExtraCost;       % extra cost per MW above min
array[1..K] of int: StartCost;         % start‑up cost of a unit of type k

/* Derived parameters */
int: totalUnits = sum(k in 1..K)(NumGenerator[k]);

/* For every physical unit we store its generator type */
array[1..totalUnits] of int: typeOf = [ k | k in 1..K, i in 1..NumGenerator[k] ];

/* Decision variables */
array[1..T, 1..totalUnits] of var 0..1: online;   % 1 = unit on, 0 = off
array[1..T, 1..totalUnits] of var int: gen;       % output of the unit
array[1..T, 1..totalUnits] of var 0..1: start;    % 1 = unit started in period

/* Generation bounds */
constraint
  forall(t in 1..T, u in 1..totalUnits) (
    online[t,u] = 1 -> MinLevel[typeOf[u]] <= gen[t,u] /\ gen[t,u] <= MaxLevel[typeOf[u]]
  );
constraint
  forall(t in 1..T, u in 1..totalUnits) (
    online[t,u] = 0 -> gen[t,u] = 0
  );

/* Start‑up linking */
constraint
  forall(u in 1..totalUnits) (
    start[1,u] = online[1,u]
  );
constraint
  forall(t in 2..T, u in 1..totalUnits) (
    start[t,u] >= online[t,u] - online[t-1,u] /\ 
    start[t,u] <= online[t,u] /\ 
    start[t,u] <= 1 - online[t-1,u]
  );

/* Demand satisfaction – each period must be met exactly */
constraint
  forall(t in 1..T)(
    sum(u in 1..totalUnits) gen[t,u] == Demand[t]
  );

/* Objective – total cost over all periods and units */
var float: totalCost = 
  sum(t in 1..T, u in 1..totalUnits)(
    RunCost[typeOf[u]] * online[t,u] +
    ExtraCost[typeOf[u]] * (gen[t,u] - MinLevel[typeOf[u]] * online[t,u]) +
    StartCost[typeOf[u]] * start[t,u]
  );

solve minimize totalCost;

/* Output */
output [
  "Total cost: ", show(totalCost), "\n",
  "Period | Unit | Type | Online | Gen | Start\n",
  "-------------------------------------------\n",
  forall(t in 1..T)(
    forall(u in 1..totalUnits)(
      "t=" ++ show(t) ++ " u=" ++ show(u) ++
      " type=" ++ show(typeOf[u]) ++
      " on=" ++ show(online[t,u]) ++
      " g=" ++ show(gen[t,u]) ++
      " s=" ++ show(start[t,u]) ++ "\n"
    )
  )
];