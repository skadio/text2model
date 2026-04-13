% Parameters
int: nSectors = 9;                       % number of sectors (nodes)
set of int: SECTOR = 0..nSectors-1;      % sector indices

int: source = 0;                         % Central Supply Hub (Sector 0)
int: sink   = 8;                         % Farthest Outpost (Sector 8)

array[SECTOR, SECTOR] of int: cap =      % capacity matrix (cap[i,j]=0 => no arc)
[
|  0,  7,  4, 17,  4, 18, 17,  5, 14
|  2,  0, 11, 10,  1, 19,  6, 16, 13
|  8, 15,  0,  5,  1,  5, 11, 17, 18
|  2,  5,  0,  0,  6, 17,  1, 16, 14
| 15,  6, 20, 15,  0,  7, 13,  6, 19
| 15,  2,  8,  2,  3,  0,  2,  9,  2
| 10, 12, 11, 10, 19,  9,  0, 17,  1
|  0, 20, 15, 19, 20, 18, 14,  0,  8
| 16, 13,  3,  3, 20, 19,  2,  7,  0
];

int: maxCap = max([cap[i,j] | i in SECTOR, j in SECTOR]);  % upper bound helper

% Variables
array[SECTOR, SECTOR] of var 0..maxCap: flow;  % flow on each directed tube (i->j)
var 0..(nSectors * maxCap): total_flow;         % total flow from source to sink

% Constraints

% --- Capacity feasibility / arc existence ---
% Enforce that flow cannot exceed capacity; if cap[i,j]=0 then flow[i,j]=0 automatically.
constraint
  forall(i in SECTOR, j in SECTOR) (
    flow[i,j] <= cap[i,j]
  );

% --- No self-loops ---
% Disallow sending flow from a sector to itself.
constraint
  forall(i in SECTOR) (
    flow[i,i] = 0
  );

% --- Flow conservation at intermediate sectors ---
% For every sector except source and sink: inflow equals outflow.
constraint
  forall(v in SECTOR where v != source /\ v != sink) (
    sum(i in SECTOR)(flow[i,v]) = sum(j in SECTOR)(flow[v,j])
  );

% --- Total flow definition ---
% Total flow is the net flow leaving the source (equivalently entering the sink by conservation).
constraint
  total_flow = sum(j in SECTOR)(flow[source,j]) - sum(i in SECTOR)(flow[i,source]);

% --- Consistency at sink (optional redundancy for clarity) ---
% The net flow entering the sink equals total_flow.
constraint
  total_flow = sum(i in SECTOR)(flow[i,sink]) - sum(j in SECTOR)(flow[sink,j]);

% Objective
solve maximize total_flow;