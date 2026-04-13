% Parameters
int: NumMachines; % Number of machines (M)
int: NumParts;    % Number of part types (P)

set of int: MACHINES = 1..NumMachines;
set of int: PARTS    = 1..NumParts;

array[MACHINES, PARTS] of int: TimeRequired; % Hours on machine m per batch of part p
array[MACHINES] of int: MachineCosts;        % Cost per hour for machine m (in-house machines)
array[MACHINES] of int: Availability;        % Normal hours available for machine m
array[PARTS] of int: Prices;                 % Revenue per batch of part p
array[PARTS] of int: MinBatches;             % Minimum batches required for part p

int: StandardCost; % Standard labor cost per hour for outsourced machine (machine 1)
int: OvertimeCost; % Overtime labor cost per hour for outsourced machine (machine 1)

array[MACHINES] of int: OvertimeHour; % Overtime hours available for machine m

% Variables
array[PARTS] of var int: Batches; % Number of batches to produce of each part p

var int: StandardHours_M1; % Normal (non-overtime) hours used on outsourced machine 1
var int: OvertimeHours_M1; % Overtime hours used on outsourced machine 1

% Constraints

% --- Minimum production to satisfy contracts (also implies non-negativity given MinBatches >= 0) ---
constraint
  forall(p in PARTS) (
    Batches[p] >= MinBatches[p]
  );

% --- Explicit non-negativity (kept for robustness if some MinBatches could be negative in data) ---
constraint
  forall(p in PARTS) (
    Batches[p] >= 0
  );

% --- Machine capacity constraints for in-house machines (machines 2..M) ---
% Total hours used on each machine must not exceed normal + overtime availability.
constraint
  forall(m in MACHINES where m != 1) (
    sum(p in PARTS)(TimeRequired[m,p] * Batches[p])
    <= Availability[m] + OvertimeHour[m]
  );

% --- Outsourced machine (machine 1): link total required hours to standard + overtime hours ---
constraint
  StandardHours_M1 + OvertimeHours_M1
  = sum(p in PARTS)(TimeRequired[1,p] * Batches[p]);

% --- Standard and overtime hour bounds for outsourced machine 1 ---
constraint
  0 <= StandardHours_M1 /\ StandardHours_M1 <= Availability[1];

constraint
  0 <= OvertimeHours_M1 /\ OvertimeHours_M1 <= OvertimeHour[1];

% Objective
solve maximize
  sum(p in PARTS)(Prices[p] * Batches[p])
  - (
      StandardCost * StandardHours_M1
      + OvertimeCost * OvertimeHours_M1
      + sum(m in MACHINES where m != 1)(
          MachineCosts[m] * sum(p in PARTS)(TimeRequired[m,p] * Batches[p])
        )
    );