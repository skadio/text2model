int: M;
int: P;

set of int: MACHINES = 1..M;
set of int: PARTS = 1..P;

array[MACHINES, PARTS] of float: TimeRequired;
array[MACHINES] of float: MachineCosts;
array[MACHINES] of int: Availability;

array[PARTS] of float: Prices;
array[PARTS] of int: MinBatches;

array[MACHINES] of float: ExtraCosts;
array[MACHINES] of int: MaxExtra;

% Decision variables
array[PARTS] of var int: Batches;              % batches of 100 parts to produce
array[MACHINES] of var 0..max(MaxExtra): ExtraHours;

% Upper bound on batches based on total possible machine time (availability + max extra)
function int: ub_batches(int: p) =
  let {
    int: BIG = 1000000000,
    array[MACHINES] of int: ubm = [
      if TimeRequired[m,p] > 0.0 then
        floor( (int2float(Availability[m] + MaxExtra[m])) / TimeRequired[m,p] )
      else
        BIG
      endif
      | m in MACHINES
    ]
  } in min(ubm);

constraint
  forall(p in PARTS) (
    Batches[p] >= MinBatches[p] /\ Batches[p] <= ub_batches(p)
  );

% Machine capacity with purchasable extra time
constraint
  forall(m in MACHINES) (
    ExtraHours[m] <= MaxExtra[m] /\
    sum(p in PARTS)( TimeRequired[m,p] * int2float(Batches[p]) )
      <= int2float(Availability[m]) + int2float(ExtraHours[m])
  );

% Objective: maximize profit = revenue - regular machine operating cost - extra-hour cost
var float: Revenue =
  sum(p in PARTS)( Prices[p] * int2float(Batches[p]) );

var float: RegularCost =
  sum(m in MACHINES)(
    MachineCosts[m] * sum(p in PARTS)( TimeRequired[m,p] * int2float(Batches[p]) )
  );

var float: ExtraCost =
  sum(m in MACHINES)( ExtraCosts[m] * int2float(ExtraHours[m]) );

var float: Profit = Revenue - RegularCost - ExtraCost;

solve maximize Profit;

output [
  "Batches = ", show(Batches), "\n",
  "ExtraHours = ", show(ExtraHours), "\n",
  "Revenue = ", show(Revenue), "\n",
  "RegularCost = ", show(RegularCost), "\n",
  "ExtraCost = ", show(ExtraCost), "\n",
  "Profit = ", show(Profit), "\n"
];