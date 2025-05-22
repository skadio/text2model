% Parameters
int: M;                       % Number of machines
int: P;                       % Number of parts

array[1..M, 1..P] of int: TimeRequired;   % Hours needed on machine m for a batch of part p
array[1..M] of float: MachineCosts;       % Cost per hour of running machine m
array[1..M] of int: Availability;         % Regularly available hours on machine m
array[1..P] of float: Prices;             % Revenue from selling one batch of part p
array[1..P] of int: MinBatches;           % Contracted minimum batches of part p
array[1..M] of float: ExtraCosts;         % Additional cost per overtime hour on machine m
array[1..M] of int: MaxExtra;             % Maximum overtime hours that can be bought for machine m

% Decision variables
array[1..P] of var int: Batches;          % Batches to produce for each part
array[1..M] of var float: ExtraHours;     % Overtime hours purchased for each machine

% Constraints

% Minimum contractual production and non-negativity
constraint
  forall(p in 1..P)(
    Batches[p] >= MinBatches[p] /\ Batches[p] >= 0
  );

% Bounds on overtime hours
constraint
  forall(m in 1..M)(
    ExtraHours[m] >= 0.0 /\ ExtraHours[m] <= float(MaxExtra[m])
  );

% Machine–time capacity (regular + overtime)
constraint
  forall(m in 1..M)(
    float( sum(p in 1..P)( TimeRequired[m,p] * Batches[p] ) )
    <= float(Availability[m]) + ExtraHours[m]
  );

% Overtime must cover every hour above regular availability
constraint
  forall(m in 1..M)(
    ExtraHours[m] >=
      float( sum(p in 1..P)( TimeRequired[m,p] * Batches[p] ) ) - float(Availability[m])
  );

% Objective: maximize profit
var float: Profit =
      sum(p in 1..P)( Prices[p] * float(Batches[p]) )
    - sum(m in 1..M)(
        MachineCosts[m] *
        ( sum(p in 1..P)( float(TimeRequired[m,p]) * float(Batches[p]) ) )
      )
    - sum(m in 1..M)( ExtraCosts[m] * ExtraHours[m] );

solve maximize Profit;