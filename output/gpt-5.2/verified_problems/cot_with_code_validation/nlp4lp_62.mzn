% Parameters
int: M;
int: P;

array[1..M, 1..P] of int: TimeRequired;
array[1..M] of int: MachineCosts;     % cost per hour on machine m
array[1..M] of int: Availability;     % hours available on machine m per month
array[1..P] of int: Prices;           % revenue per batch of part p
array[1..P] of int: SetupTime;        % setup hours on machine 1 if part p is produced

% Decision variables
array[1..P] of var 0..max(Availability): Batches;  % number of 100-part batches of part p
array[1..P] of var bool: Produce;                  % whether part p is produced at all

% Link production to setup requirement
constraint forall(p in 1..P) (
  Batches[p] <= max(Availability) * bool2int(Produce[p])
);

% Machine capacity constraints (setup time only on machine 1, and only if produced)
constraint forall(m in 1..M) (
  sum(p in 1..P)(
    TimeRequired[m,p] * Batches[p]
    + (if m = 1 then SetupTime[p] * bool2int(Produce[p]) else 0 endif)
  ) <= Availability[m]
);

% Objective: maximize profit = revenue - operating costs
var int: Profit =
  sum(p in 1..P)(Prices[p] * Batches[p])
  - sum(m in 1..M)(
      MachineCosts[m] * sum(p in 1..P)(
        TimeRequired[m,p] * Batches[p]
        + (if m = 1 then SetupTime[p] * bool2int(Produce[p]) else 0 endif)
      )
    );

solve maximize Profit;

output [
  "Profit = ", show(Profit), "\n",
  "Batches = ", show(Batches), "\n",
  "Produce = ", show(Produce), "\n"
];