int: NumLinks;
set of int: LINKS = 1..NumLinks;

array[LINKS] of int: StartNode;
array[LINKS] of int: EndNode;
array[LINKS] of int: Capacity;
array[LINKS] of int: Cost;

int: NumFlowReqs;
set of int: FLOWS = 1..NumFlowReqs;

array[FLOWS] of int: SourceNode;
array[FLOWS] of int: DestinationNode;
array[FLOWS] of int: DataRate;

% Derive node set from data
int: NumNodes = max(
  max([StartNode[l] | l in LINKS] ++ [EndNode[l] | l in LINKS]),
  max([SourceNode[f] | f in FLOWS] ++ [DestinationNode[f] | f in FLOWS])
);
set of int: NODES = 1..NumNodes;

% Flow on each directed link for each commodity (can be split)
array[FLOWS, LINKS] of var 0..max(DataRate): Flow;

% Capacity constraints per link (sum over all flows)
constraint
  forall(l in LINKS) (
    sum(f in FLOWS)(Flow[f,l]) <= Capacity[l]
  );

% Flow conservation for each flow requirement at each node
constraint
  forall(f in FLOWS, n in NODES) (
    sum(l in LINKS where EndNode[l] = n)(Flow[f,l]) -
    sum(l in LINKS where StartNode[l] = n)(Flow[f,l])
    =
    (if n = DestinationNode[f] then DataRate[f] else 0 endif) -
    (if n = SourceNode[f] then DataRate[f] else 0 endif)
  );

% Objective: minimize total transmission cost
var int: TotalCost = sum(f in FLOWS, l in LINKS)(Cost[l] * Flow[f,l]);

solve minimize TotalCost;

output [
  "TotalCost = ", show(TotalCost), "\n",
  "Flow[f,l] (rows=f, cols=l):\n",
  show(Flow), "\n"
];