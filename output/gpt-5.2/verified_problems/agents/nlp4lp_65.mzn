% Parameters
int: N;                                   % Number of interventions (clusters)
set of int: INTERVENTIONS = 1..N;         % Index set for interventions

array[INTERVENTIONS] of int: IsolateCentral;       % Time to isolate via central for each intervention
array[INTERVENTIONS] of int: ScanCentral;          % Time to scan via central for each intervention
array[INTERVENTIONS] of int: IsolateDistributed;   % Time to isolate via distributed for each intervention
array[INTERVENTIONS] of int: ScanDistributed;      % Time to scan via distributed for each intervention

int: CentralCost;                         % Opportunity cost per central-processed intervention
int: DistributedCost;                     % Opportunity cost per distributed-processed intervention
int: CentralMaxHours;                     % Max available central processing hours
int: DistributedMaxHours;                 % Max available distributed processing hours


% Variables
array[INTERVENTIONS] of var bool: useCentral;      % true if intervention is processed centrally, else distributed
array[INTERVENTIONS] of var bool: doIsolate;       % true if intervention uses isolate action, else scan action

array[INTERVENTIONS] of var int: procTime;         % Processing time chosen for each intervention

% Upper bounds are safe over-approximations (sum of per-intervention maxima).
var 0..sum(i in INTERVENTIONS)(max(IsolateCentral[i], ScanCentral[i])): totalCentralHours;
var 0..sum(i in INTERVENTIONS)(max(IsolateDistributed[i], ScanDistributed[i])): totalDistributedHours;

array[INTERVENTIONS] of var int: interventionCost; % Cost incurred for each intervention based on processing location
var 0..N * max(CentralCost, DistributedCost): totalCost; % Total opportunity cost across all interventions


% Constraints
% --- Processing time selection per intervention (action + location) ---
constraint
  forall(i in INTERVENTIONS) (
    useCentral[i] ->
      procTime[i] =
        (bool2int(doIsolate[i]) * IsolateCentral[i] +
         bool2int(not doIsolate[i]) * ScanCentral[i])
  );

constraint
  forall(i in INTERVENTIONS) (
    (not useCentral[i]) ->
      procTime[i] =
        (bool2int(doIsolate[i]) * IsolateDistributed[i] +
         bool2int(not doIsolate[i]) * ScanDistributed[i])
  );

% --- Aggregate central and distributed hours from chosen interventions ---
constraint
  totalCentralHours =
    sum(i in INTERVENTIONS) ( bool2int(useCentral[i]) * procTime[i] );

constraint
  totalDistributedHours =
    sum(i in INTERVENTIONS) ( bool2int(not useCentral[i]) * procTime[i] );

% --- Respect maximum available processing hours ---
constraint totalCentralHours <= CentralMaxHours;
constraint totalDistributedHours <= DistributedMaxHours;

% --- Cost per intervention based on processing location ---
constraint
  forall(i in INTERVENTIONS) (
    interventionCost[i] =
      bool2int(useCentral[i]) * CentralCost +
      bool2int(not useCentral[i]) * DistributedCost
  );

% --- Total opportunity cost aggregation ---
constraint
  totalCost = sum(i in INTERVENTIONS) (interventionCost[i]);


% Objective
solve minimize totalCost;