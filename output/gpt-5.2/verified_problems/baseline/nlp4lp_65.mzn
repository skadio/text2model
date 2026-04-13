int: N;

array[1..N] of int: IsolateCentral;
array[1..N] of int: ScanCentral;
array[1..N] of int: IsolateDistributed;
array[1..N] of int: ScanDistributed;

int: CentralCost;
int: DistributedCost;

int: CentralMaxHours;
int: DistributedMaxHours;

% Decision variables:
% action[i] = 1 => Isolate, 2 => Scan
% proc[i]   = 1 => Central, 2 => Distributed
array[1..N] of var 1..2: action;
array[1..N] of var 1..2: proc;

% Derived times per intervention
array[1..N] of var int: time;
constraint
  forall(i in 1..N) (
    time[i] =
      if proc[i] = 1 then
        if action[i] = 1 then IsolateCentral[i] else ScanCentral[i] endif
      else
        if action[i] = 1 then IsolateDistributed[i] else ScanDistributed[i] endif
      endif
  );

% Capacity constraints (hours)
constraint
  sum(i in 1..N)( time[i] * bool2int(proc[i] = 1) ) <= CentralMaxHours
  /\
  sum(i in 1..N)( time[i] * bool2int(proc[i] = 2) ) <= DistributedMaxHours;

% Cost: opportunity cost per intervention depending on processing location
var int: total_cost =
  sum(i in 1..N)(
    CentralCost * bool2int(proc[i] = 1) +
    DistributedCost * bool2int(proc[i] = 2)
  );

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "central_hours=", show(sum(i in 1..N)( time[i] * bool2int(proc[i] = 1) )), "\n",
  "distributed_hours=", show(sum(i in 1..N)( time[i] * bool2int(proc[i] = 2) )), "\n",
  "action=", show(action), "\n",
  "proc=", show(proc), "\n",
  "time=", show(time), "\n"
];