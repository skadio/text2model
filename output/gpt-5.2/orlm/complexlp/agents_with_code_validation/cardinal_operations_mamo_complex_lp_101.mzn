% Maximum flow in a directed network (6 hubs: 0..5)

int: nHubs = 6;
set of int: HUB = 0..nHubs-1;
int: source = 0;
int: sink = 5;

% Road capacities (tons/day); 0 means no direct connection
array[HUB, HUB] of int: cap =
array2d(HUB, HUB, [
  0,  7,  8,  1,  2,  4,
 15,  0, 16,  0,  9, 13,
  9,  1,  0,  9, 13, 13,
 10, 11, 19,  0,  1, 12,
 15, 16,  7, 11,  0, 19,
 10, 12, 12, 12, 20,  0
]);

int: maxCap = max([cap[i,j] | i in HUB, j in HUB]);

array[HUB, HUB] of var 0..maxCap: flow;
var 0..(nHubs * maxCap): totalFlow;

% Capacity constraints (also forces 0 flow where cap is 0)
constraint forall(i in HUB, j in HUB) (flow[i,j] <= cap[i,j]);

% No self-loops
constraint forall(i in HUB) (flow[i,i] = 0);

% Flow conservation at intermediate hubs
constraint
  forall(k in HUB where k != source /\ k != sink) (
    sum(i in HUB)(flow[i,k]) = sum(j in HUB)(flow[k,j])
  );

% Total flow: net out of source equals net into sink
constraint totalFlow = sum(j in HUB)(flow[source,j]) - sum(i in HUB)(flow[i,source]);
constraint totalFlow = sum(i in HUB)(flow[i,sink]) - sum(j in HUB)(flow[sink,j]);

solve maximize totalFlow;