% Parameters
int: M; % number of machines
int: P; % number of parts

array[1..M, 1..P] of int: TimeRequired; % hours required on machine m to make one batch of part p
array[1..M] of int: MachineCosts;       % cost per hour for regular operation of machine m
array[1..M] of int: Availability;       % regular available hours of machine m per month

array[1..P] of int: Prices;             % selling price per batch of part p
array[1..P] of int: MinBatches;         % minimum batches required for part p

array[1..M] of float: ExtraCosts;       % extra cost per hour for purchased time on machine m
array[1..M] of int: MaxExtra;           % maximum purchasable extra hours for machine m

% To avoid float-linear issues in some solvers (e.g., Gecode),
% scale all monetary values to integers.
int: SCALE = 100; % cents (or just 2-decimal fixed-point)

array[1..M] of int: ExtraCostsScaled = [ round(ExtraCosts[m] * SCALE) | m in 1..M ];
array[1..P] of int: PricesScaled     = [ Prices[p] * SCALE | p in 1..P ];
array[1..M] of int: MachineCostsScaled = [ MachineCosts[m] * SCALE | m in 1..M ];

% Variables
array[1..P] of var int: Batches;        % number of batches of each part p to produce
array[1..M] of var int: ExtraHours;     % extra hours purchased for machine m
array[1..M] of var int: UsedHours;      % total hours used on machine m (derived)

% Constraints

% --- Contract / feasibility: meet minimum batch requirements ---
constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
);

% --- Purchased extra time bounds per machine ---
constraint forall(m in 1..M) (
  0 <= ExtraHours[m] /\ ExtraHours[m] <= MaxExtra[m]
);

% --- Define machine utilization from the production plan (derived variable) ---
constraint forall(m in 1..M) (
  UsedHours[m] = sum(p in 1..P)(TimeRequired[m,p] * Batches[p])
);

% --- Machine capacity: regular availability plus purchasable extra hours ---
constraint forall(m in 1..M) (
  UsedHours[m] <= Availability[m] + ExtraHours[m]
);

% Objective (maximize profit, scaled)
solve maximize
  sum(p in 1..P)(PricesScaled[p] * Batches[p])
  - sum(m in 1..M)(MachineCostsScaled[m] * UsedHours[m])
  - sum(m in 1..M)(ExtraCostsScaled[m] * ExtraHours[m]);