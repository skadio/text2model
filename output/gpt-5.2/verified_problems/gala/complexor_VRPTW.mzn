include "globals.mzn";

%========================
% Input data (.dzn)
%========================
int: CustomerCount;
int: VehicleCount;

array[1..CustomerCount] of int: CustomerDemand;
array[1..CustomerCount] of int: CustomerLBTW;
array[1..CustomerCount] of int: CustomerUBTW;
array[1..CustomerCount, 1..CustomerCount] of int: CustomerDistance;
array[1..CustomerCount] of int: CustomerServiceTime;
array[1..VehicleCount] of int: VehicleCapacity;

%========================
% Sets / indices
%========================
set of int: C = 1..CustomerCount;        % customers
set of int: V = 1..VehicleCount;         % vehicles

% A conservative horizon for times
int: TMIN = min([CustomerLBTW[i] | i in C]);
int: TMAX = max([CustomerUBTW[i] | i in C]) + sum([CustomerServiceTime[i] | i in C]);

%========================
% Decision variables
%========================
% assign[c,v] = 1 if customer c is served by vehicle v
array[C, V] of var 0..1: assign;

% order[c] = position of customer c in the global visit sequence of its vehicle
% Used to break subtours and define a route order per vehicle.
array[C] of var 1..CustomerCount: order;

% start service time at customer
array[C] of var TMIN..TMAX: startTime;

% predecessor / successor on the same vehicle
% prev[c] = customer immediately before c on its vehicle route, or 0 if first
% next[c] = customer immediately after c on its vehicle route, or 0 if last
array[C] of var 0..CustomerCount: prev;
array[C] of var 0..CustomerCount: next;

% derived: which vehicle serves each customer
array[C] of var 1..VehicleCount: veh;

%========================
% Core constraints
%========================

% Each customer is assigned to exactly one vehicle
constraint forall(c in C) (
  sum(v in V)(assign[c,v]) = 1
);

% Link veh with assign
constraint forall(c in C) (
  sum(v in V)(v * assign[c,v]) = veh[c]
);

% Vehicle capacity
constraint forall(v in V) (
  sum(c in C)(CustomerDemand[c] * assign[c,v]) <= VehicleCapacity[v]
);

% Time windows
constraint forall(c in C) (
  startTime[c] >= CustomerLBTW[c] /\
  startTime[c] <= CustomerUBTW[c]
);

% prev/next domains: cannot point to self
constraint forall(c in C) ( prev[c] != c /\ next[c] != c );

% Mutual consistency of prev/next (if a is next of b then b is prev of a)
constraint forall(a in C, b in C where a != b) (
  (next[a] = b) <-> (prev[b] = a)
);

% If customer c is first, prev[c]=0; if last, next[c]=0 are allowed.
% Ensure at most one prev and one next per customer (already implied by being single vars),
% and forbid multiple customers claiming same next/prev via all_different on the nonzero part
% using a reification-friendly approach: allow duplicates of 0 only.
%
% For that, create "next_or_self" trick not needed; instead:
% Use global_cardinality on next and prev to allow 0 multiple times, others at most 1.
array[0..CustomerCount] of var 0..CustomerCount: occNext;
array[0..CustomerCount] of var 0..CustomerCount: occPrev;
constraint global_cardinality(next, 0..CustomerCount, occNext);
constraint global_cardinality(prev, 0..CustomerCount, occPrev);
constraint occNext[0] >= 0 /\ occPrev[0] >= 0;
constraint forall(c in C) ( occNext[c] <= 1 /\ occPrev[c] <= 1 );

% Same-vehicle consistency for arcs:
% if next[i]=j then veh[i]=veh[j]; similarly for prev (redundant but helpful)
constraint forall(i in C, j in C where i != j) (
  (next[i] = j) -> (veh[i] = veh[j])
);
constraint forall(i in C, j in C where i != j) (
  (prev[i] = j) -> (veh[i] = veh[j])
);

% Order consistency along arcs:
constraint forall(i in C, j in C where i != j) (
  (next[i] = j) -> (order[j] = order[i] + 1)
);

% If prev[c]=0 then order[c]=1 (first in its vehicle), otherwise order[c] >= 2
constraint forall(c in C) (
  (prev[c] = 0) <-> (order[c] = 1)
);

% Time propagation along arcs:
% If next[i]=j then startTime[j] >= startTime[i] + service[i] + distance[i,j]
constraint forall(i in C, j in C where i != j) (
  (next[i] = j) -> (startTime[j] >= startTime[i] + CustomerServiceTime[i] + CustomerDistance[i,j])
);

% Enforce exactly one first and one last per vehicle IF it serves any customer.
% First: customers with prev=0 on that vehicle. Last: customers with next=0 on that vehicle.
constraint forall(v in V) (
  let {
    var 0..CustomerCount: served = sum(c in C)(assign[c,v]),
    var 0..CustomerCount: firstCnt = sum(c in C)(bool2int(assign[c,v] = 1 /\ prev[c] = 0)),
    var 0..CustomerCount: lastCnt  = sum(c in C)(bool2int(assign[c,v] = 1 /\ next[c] = 0))
  } in
    (served = 0 -> (firstCnt = 0 /\ lastCnt = 0)) /\
    (served > 0 -> (firstCnt = 1 /\ lastCnt = 1))
);

% Ensure number of arcs within each vehicle equals served-1:
constraint forall(v in V) (
  let {
    var 0..CustomerCount: served = sum(c in C)(assign[c,v]),
    var 0..CustomerCount: arcCnt = sum(c in C)(bool2int(assign[c,v] = 1 /\ next[c] != 0))
  } in
    arcCnt = max(served - 1, 0)
);

%========================
% Objective: minimize total travel cost (within customer network only)
% Without explicit depots in the input, we minimize customer-to-customer arc distances.
%========================
var int: totalCost =
  sum(i in C, j in C where i != j)(
    CustomerDistance[i,j] * bool2int(next[i] = j)
  );

solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "veh = ", show(veh), "\n",
  "order = ", show(order), "\n",
  "prev = ", show(prev), "\n",
  "next = ", show(next), "\n",
  "startTime = ", show(startTime), "\n",
  "assign = ", show(assign), "\n"
];