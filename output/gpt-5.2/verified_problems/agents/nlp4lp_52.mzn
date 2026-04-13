% Parameters
int: M; % Number of machines
int: P; % Number of parts

set of int: MACHINES = 1..M; % Machine index set
set of int: PARTS    = 1..P; % Part index set

array[MACHINES, PARTS] of int: TimeRequired; % Hours required on machine m to make one batch of part p
array[MACHINES] of int: MachineCosts;        % Operating cost per hour for machine m
array[MACHINES] of int: Availability;        % Monthly available hours for machine m
array[PARTS] of int: Prices;                 % Selling price per batch of part p
array[PARTS] of int: MinBatches;             % Contractual minimum batches of part p

% (Derived bounds to keep decision variables bounded)
int: maxAvailability = max(m in MACHINES)(Availability[m]); % Upper bound helper
int: minPositiveTime =
  min(m in MACHINES, p in PARTS where TimeRequired[m,p] > 0)(TimeRequired[m,p]);
int: maxBatchesUpper =
  if minPositiveTime > 0 then maxAvailability div minPositiveTime else maxAvailability endif;

% Variables
array[PARTS] of var 0..maxBatchesUpper: Batches; % Batches of each part p to produce (each batch = 100 parts)
var int: Profit;                                 % Total monthly profit (revenue - machine operating costs)


% Constraints

% --- Contractual minimum production requirements ---
constraint
  forall(p in PARTS) (
    Batches[p] >= MinBatches[p]
  );

% --- Machine capacity constraints (machines 1..M-2 individually) ---
% Each machine m (except the last two) must not exceed its own monthly availability.
constraint
  forall(m in MACHINES where m <= M - 2) (
    sum(p in PARTS) (TimeRequired[m,p] * Batches[p]) <= Availability[m]
  );

% --- Shared capacity constraint for machines M-1 and M ---
% Machines M and M-1 share availability, so only the combined usage is bounded by combined availability.
constraint
  if M >= 2 then
    sum(p in PARTS) (TimeRequired[M-1,p] * Batches[p])
  + sum(p in PARTS) (TimeRequired[M,p]   * Batches[p])
  <= Availability[M-1] + Availability[M]
  else
    true
  endif;

% --- Profit definition (revenue minus operating costs) ---
constraint
  Profit =
    sum(p in PARTS) (Prices[p] * Batches[p])
    - sum(m in MACHINES) (
        MachineCosts[m] * sum(p in PARTS) (TimeRequired[m,p] * Batches[p])
      );


% Objective
solve maximize Profit;