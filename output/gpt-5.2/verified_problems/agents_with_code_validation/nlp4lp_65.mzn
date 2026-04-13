% Parameters
int: N; % Number of interventions/clusters

set of int: INTERVENTIONS = 1..N; % Index set for interventions

array[INTERVENTIONS] of int: IsolateCentral;      % Time to isolate using central processing (per intervention)
array[INTERVENTIONS] of int: ScanCentral;         % Time to scan using central processing (per intervention)
array[INTERVENTIONS] of int: IsolateDistributed;  % Time to isolate using distributed processing (per intervention)
array[INTERVENTIONS] of int: ScanDistributed;     % Time to scan using distributed processing (per intervention)

int: CentralCost;      % Opportunity cost per central intervention (used in objective)
int: DistributedCost;  % Opportunity cost per distributed intervention (used in objective)

int: CentralMaxHours;      % Max available central processing hours
int: DistributedMaxHours;  % Max available distributed processing hours


% Variables
array[INTERVENTIONS] of var bool: useCentral; % true if intervention is executed centrally, false if distributed
array[INTERVENTIONS] of var bool: doIsolate;  % true = isolate, false = scan

array[INTERVENTIONS] of var int: centralHours;     % Hours consumed on central by intervention (0 if not central)
array[INTERVENTIONS] of var int: distributedHours; % Hours consumed on distributed by intervention (0 if not distributed)

var 0..sum(i in INTERVENTIONS)(max(IsolateCentral[i], ScanCentral[i])): totalCentralHours; % Total central hours used
var 0..sum(i in INTERVENTIONS)(max(IsolateDistributed[i], ScanDistributed[i])): totalDistributedHours; % Total distributed hours used

var 0..N * max(CentralCost, DistributedCost): totalCost; % Total cost of chosen interventions


% Constraints
%--- Per-intervention processing time assignment (central vs distributed; isolate vs scan)
constraint
  forall(i in INTERVENTIONS) (
    centralHours[i] =
      bool2int(useCentral[i]) *
      ( bool2int(doIsolate[i]) * IsolateCentral[i]
        + (1 - bool2int(doIsolate[i])) * ScanCentral[i]
      )
  );

constraint
  forall(i in INTERVENTIONS) (
    distributedHours[i] =
      (1 - bool2int(useCentral[i])) *
      ( bool2int(doIsolate[i]) * IsolateDistributed[i]
        + (1 - bool2int(doIsolate[i])) * ScanDistributed[i]
      )
  );

%--- Aggregate total hours for each processing mode
constraint
  totalCentralHours = sum(i in INTERVENTIONS)(centralHours[i]);

constraint
  totalDistributedHours = sum(i in INTERVENTIONS)(distributedHours[i]);

%--- Capacity limits (maximum available hours)
constraint
  totalCentralHours <= CentralMaxHours;

constraint
  totalDistributedHours <= DistributedMaxHours;

%--- Total cost accounting
constraint
  totalCost =
    sum(i in INTERVENTIONS)(
      bool2int(useCentral[i]) * CentralCost
      + (1 - bool2int(useCentral[i])) * DistributedCost
    );


% Objective
solve minimize totalCost;