% Parameters
int: M; % number of machines
int: P; % number of parts

array[1..M, 1..P] of int: TimeRequired; % hours required to produce 1 batch of part p on machine m
array[1..M] of int: MachineCosts;       % cost per hour for regular operation of machine m
array[1..M] of int: Availability;       % regular available hours of machine m per month

array[1..P] of int: Prices;             % selling price per batch of part p
array[1..P] of int: MinBatches;         % minimum batches of part p to produce per month

array[1..M] of float: ExtraCosts;       % extra cost per hour beyond regular operation for machine m
array[1..M] of int: MaxExtra;           % maximum purchasable extra hours for machine m per month


% Variables
array[1..P] of var int: Batches;              % number of batches to produce of each part p (integer batches)
array[1..M] of var int: ExtraHoursPurchased;  % extra hours purchased for each machine m (integer hours)

var float: Profit; % total monthly profit


% Constraints
%--- Contract fulfillment: meet minimum production per part
constraint
  forall(p in 1..P) (
    Batches[p] >= MinBatches[p]
  );

%--- Nonnegativity: production and purchased extra hours cannot be negative
constraint
  forall(p in 1..P) (
    Batches[p] >= 0
  );

constraint
  forall(m in 1..M) (
    ExtraHoursPurchased[m] >= 0
  );

%--- Limit on purchasable extra hours per machine
constraint
  forall(m in 1..M) (
    ExtraHoursPurchased[m] <= MaxExtra[m]
  );

%--- Machine capacity: total used hours must not exceed regular + purchased extra hours
constraint
  forall(m in 1..M) (
    sum(p in 1..P) (TimeRequired[m,p] * Batches[p])
    <= Availability[m] + ExtraHoursPurchased[m]
  );

%--- Profit definition (revenue - regular running costs - extra hour costs)
% Regular running costs apply to all used hours; extra costs apply only to purchased extra hours.
constraint
  Profit =
    sum(p in 1..P) ( float(Prices[p]) * float(Batches[p]) )
    - sum(m in 1..M) (
        float(MachineCosts[m]) * sum(p in 1..P) ( float(TimeRequired[m,p]) * float(Batches[p]) )
      )
    - sum(m in 1..M) ( ExtraCosts[m] * float(ExtraHoursPurchased[m]) );


% Objective
solve maximize Profit;