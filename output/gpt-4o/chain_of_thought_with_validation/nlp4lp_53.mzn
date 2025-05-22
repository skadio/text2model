% Parameters
int: M;
int: P;

set of int: Machines = 1..M;
set of int: Parts    = 1..P;

array[Machines, Parts] of float: TimeRequired;   % hours per batch of part p on machine m
array[Machines]        of float: MachineCosts;   % cost per hour on machine m
array[Machines]        of float: Availability;   % regular available hours on machine m
array[Parts]           of float: Prices;         % selling price per batch of part p
array[Parts]           of int:   MinBatches;     % minimum batches required for part p
array[Machines]        of float: ExtraCosts;     % additional cost per extra hour on machine m
array[Machines]        of float: MaxExtra;       % maximum extra hours purchasable for machine m

% Derived upper bounds on production
array[Parts] of int: MaxBatches =
  [ min([ floor((Availability[m] + MaxExtra[m]) / TimeRequired[m,p])
          | m in Machines ])
  | p in Parts ];

% Decision variables
array[Parts]    of var int:   Batches;     % batches of each part produced
array[Machines] of var float: ExtraHours;  % extra hours bought for each machine
array[Machines] of var float: HoursUsed;   % total hours used on each machine
var float: Profit;                         % objective value

% Contract requirements and logical upper bounds
constraint forall(p in Parts)(
  MinBatches[p] <= Batches[p] /\ Batches[p] <= MaxBatches[p]
);

% Hours consumed per machine
constraint forall(m in Machines)(
  HoursUsed[m] = sum(p in Parts)( TimeRequired[m,p] * int2float(Batches[p]) )
);

% Capacity including extra hours
constraint forall(m in Machines)(
  HoursUsed[m] <= Availability[m] + ExtraHours[m]
);

% Limits on extra hours
constraint forall(m in Machines)(
  0.0 <= ExtraHours[m] /\ ExtraHours[m] <= MaxExtra[m]
);

% Profit calculation
constraint
  Profit =
      sum(p in Parts)( Prices[p] * int2float(Batches[p]) )
    - sum(m in Machines)(
        MachineCosts[m] * HoursUsed[m] +
        ExtraCosts[m]   * ExtraHours[m]
      );

solve maximize Profit;