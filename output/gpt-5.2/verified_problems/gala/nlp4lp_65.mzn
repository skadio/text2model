include "globals.mzn";

%========================
% Input data
%========================
int: N;

array[1..N] of int: IsolateCentral;
array[1..N] of int: ScanCentral;
array[1..N] of int: IsolateDistributed;
array[1..N] of int: ScanDistributed;

int: CentralCost;
int: DistributedCost;

int: CentralMaxHours;
int: DistributedMaxHours;

%========================
% Decision variables
%========================
% For each intervention/cluster:
% action[i] = 1 -> Isolate, 2 -> Scan
array[1..N] of var 1..2: action;

% mode[i] = 1 -> Central processing, 2 -> Distributed processing
array[1..N] of var 1..2: mode;

% Derived time for each intervention depending on chosen action+mode
array[1..N] of var int: time_i;

%========================
% Constraints
%========================
% Define processing time based on choices
constraint
  forall(i in 1..N) (
    time_i[i] =
      if mode[i] = 1 then
        if action[i] = 1 then IsolateCentral[i] else ScanCentral[i] endif
      else
        if action[i] = 1 then IsolateDistributed[i] else ScanDistributed[i] endif
      endif
  );

% Capacity constraints: total hours used by each system
var int: centralHours = sum(i in 1..N)( (mode[i] = 1) * time_i[i] );
var int: distributedHours = sum(i in 1..N)( (mode[i] = 2) * time_i[i] );

constraint centralHours <= CentralMaxHours;
constraint distributedHours <= DistributedMaxHours;

%========================
% Objective: minimize opportunity cost
% (cost per intervention depending on chosen system)
%========================
var int: totalCost =
  sum(i in 1..N)(
    if mode[i] = 1 then CentralCost else DistributedCost endif
  );

solve minimize totalCost;

%========================
% Output
%========================
output [
  "totalCost = ", show(totalCost), "\n",
  "centralHours = ", show(centralHours), " / ", show(CentralMaxHours), "\n",
  "distributedHours = ", show(distributedHours), " / ", show(DistributedMaxHours), "\n",
  "action(1=Isolate,2=Scan) = ", show(action), "\n",
  "mode(1=Central,2=Distributed) = ", show(mode), "\n",
  "time_i = ", show(time_i), "\n"
];