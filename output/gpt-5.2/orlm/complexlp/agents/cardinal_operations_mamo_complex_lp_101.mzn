% Parameters
int: nHubs = 6;                              % number of hubs (0..5)
set of int: HUB = 0..nHubs-1;                % hub index set

int: source = 0;                             % dispatch center
int: sink   = 5;                             % destination

array[HUB, HUB] of int: cap =                % road capacity matrix (tons/day); 0 => no direct road
[|  0,  7,  8,  1,  2,  4
 | 15,  0, 16,  0,  9, 13
 |  9,  1,  0,  9, 13, 13
 | 10, 11, 19,  0,  1, 12
 | 15, 16,  7, 11,  0, 19
 | 10, 12, 12, 12, 20,  0 |];

int: maxCap = max([cap[i,j] | i in HUB, j in HUB]);   % maximum single-arc capacity
int: UBflow = (nHubs-1) * maxCap;                      % safe upper bound on any arc flow and total flow

% Variables
array[HUB, HUB] of var 0..UBflow: flow;   % flow[i,j] = tons/day sent directly from hub i to hub j
var 0..UBflow: totalFlow;                 % total tons/day delivered from source to sink

% Constraints

% --- Capacity feasibility on each directed road (respect 0 => no arc) ---
constraint
  forall(i in HUB, j in HUB) (
    flow[i,j] <= cap[i,j]
  );

% --- Flow conservation at intermediate hubs (Kirchhoff / mass balance) ---
constraint
  forall(v in HUB where v != source /\ v != sink) (
    sum(j in HUB)(flow[v,j]) = sum(i in HUB)(flow[i,v])
  );

% --- Define totalFlow as net outflow from source (equivalently, net inflow to sink) ---
constraint
  totalFlow = sum(j in HUB)(flow[source,j]) - sum(i in HUB)(flow[i,source]);

% --- Consistency check: same totalFlow equals net inflow to sink ---
constraint
  totalFlow = sum(i in HUB)(flow[i,sink]) - sum(j in HUB)(flow[sink,j]);

% Objective
solve maximize totalFlow;