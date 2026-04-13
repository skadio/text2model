% Parameters
int: M;
int: P;

array[1..M, 1..P] of int: TimeRequired;
array[1..M] of int: MachineCosts;
array[1..M] of int: Availability;
array[1..P] of int: Prices;
array[1..P] of int: SetupTime;

% Variables
array[1..P] of var int: Batches;
array[1..P] of var 0..1: Produce;

var int: Profit;

% Constraints
constraint forall(p in 1..P)(Batches[p] >= 0);

% Link setup decision to production (setup on machine 1 only if producing part p)
constraint forall(p in 1..P)(
  Batches[p] <= Availability[1] * Produce[p]
);

% Machine capacity constraints (include setup time on machine 1)
constraint forall(m in 1..M)(
  sum(p in 1..P)(TimeRequired[m,p] * Batches[p])
  + (if m = 1 then sum(p in 1..P)(SetupTime[p] * Produce[p]) else 0 endif)
  <= Availability[m]
);

% Profit definition: revenue - operating costs (cost per hour * total hours used, incl. setup on machine 1)
constraint Profit =
  sum(p in 1..P)(Prices[p] * Batches[p])
  - sum(m in 1..M)(
      MachineCosts[m] * (
        sum(p in 1..P)(TimeRequired[m,p] * Batches[p])
        + (if m = 1 then sum(p in 1..P)(SetupTime[p] * Produce[p]) else 0 endif)
      )
    );

% Objective
solve maximize Profit;