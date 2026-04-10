% Parameters
int: NumMachines;                         % Number of machines (M)
int: NumParts;                            % Number of part types (P)

set of int: MACHINES = 1..NumMachines;    % Machine index set
set of int: PARTS    = 1..NumParts;       % Part index set

array[MACHINES, PARTS] of int: TimeRequired;   % Hours required per batch of part p on machine m
array[MACHINES] of int: MachineCosts;          % Cost per hour of operating machine m (non-labor)
array[MACHINES] of int: Availability;          % Standard hours available for machine m (ignored for machine 1 capacity)
array[PARTS] of int: Prices;                   % Revenue per batch of part p
array[PARTS] of int: MinBatches;               % Minimum required batches of part p

int: StandardCost;                             % Standard labor cost per hour (machine 1)
int: OvertimeCost;                             % Overtime labor cost per hour (machine 1)
array[MACHINES] of int: OvertimeHour;          % Overtime hour limit per machine (used for machine 1; others optional)

% Variables
array[PARTS] of var 0..intmax: Batches;         % Batches produced of each part (decision variables)

var 0..intmax: LaborHoursStd;                   % Standard labor hours used on machine 1
var 0..intmax: LaborHoursOT;                    % Overtime labor hours used on machine 1

% Constraints

%-------------------------------
% Minimum production requirements
%-------------------------------
constraint
  forall(p in PARTS) (
    Batches[p] >= MinBatches[p]
  );

%--------------------------------------------
% Machine capacity constraints (machines 2..M)
% Machine 1 availability is disregarded
%--------------------------------------------
constraint
  forall(m in MACHINES where m != 1) (
    sum(p in PARTS) (TimeRequired[m,p] * Batches[p]) <= Availability[m]
  );

%---------------------------------------------------------
% Machine 1 labor hour accounting (standard + overtime)
% Total required hours on machine 1 must be covered
%---------------------------------------------------------
constraint
  LaborHoursStd + LaborHoursOT
    = sum(p in PARTS) (TimeRequired[1,p] * Batches[p]);

%---------------------------------------------------------
% Machine 1 standard and overtime hour limits
% Standard hours capped by Availability[1]
% Overtime hours capped by OvertimeHour[1]
%---------------------------------------------------------
constraint
  LaborHoursStd <= Availability[1];

constraint
  LaborHoursOT <= OvertimeHour[1];

% Objective
solve maximize
  sum(p in PARTS) (Prices[p] * Batches[p])
  - (
      sum(m in MACHINES where m != 1) (
        MachineCosts[m] * sum(p in PARTS) (TimeRequired[m,p] * Batches[p])
      )
      + StandardCost * LaborHoursStd
      + OvertimeCost * LaborHoursOT
    );