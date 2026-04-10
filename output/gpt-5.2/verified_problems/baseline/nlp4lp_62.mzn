int: M;
int: P;

set of int: Machines = 1..M;
set of int: Parts = 1..P;

array[Machines, Parts] of float: TimeRequired;
array[Machines] of float: MachineCosts;
array[Machines] of float: Availability;
array[Parts] of float: Prices;
array[Parts] of float: SetupTime;

array[Parts] of var int: Batches;          % number of 100-part batches to produce
array[Parts] of var bool: Produce;         % whether part p is produced (to trigger setup on machine 1)

constraint forall(p in Parts) (
  Batches[p] >= 0 /\
  Batches[p] <= 1000000 * bool2int(Produce[p])
);

constraint forall(m in Machines) (
  sum(p in Parts)(TimeRequired[m,p] * int2float(Batches[p]))
  + (if m == 1 then sum(p in Parts)(SetupTime[p] * bool2int(Produce[p])) else 0.0 endif)
  <= Availability[m]
);

var float: Profit =
  sum(p in Parts)(Prices[p] * int2float(Batches[p]))
  - sum(m in Machines)(
      MachineCosts[m] * (
        sum(p in Parts)(TimeRequired[m,p] * int2float(Batches[p]))
        + (if m == 1 then sum(p in Parts)(SetupTime[p] * bool2int(Produce[p])) else 0.0 endif)
      )
    );

solve maximize Profit;

output [
  "Profit = ", show(Profit), "\n",
  "Batches = ", show(Batches), "\n",
  "Produce = ", show(Produce), "\n"
];