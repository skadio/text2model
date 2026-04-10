% Minimum-Cost Multi-Commodity Flow (splittable)

%--------------------------
% Parameters
%--------------------------
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

int: MaxNode =
  max([ max(StartNode), max(EndNode), max(SourceNode), max(DestinationNode) ]);
set of int: NODES = 1..MaxNode;

%--------------------------
% Variables
%--------------------------
array[FLOWS, LINKS] of var 0..max(Capacity): FlowOnLink;

var int: TotalCost;

%--------------------------
% Constraints
%--------------------------
% Link capacity (total across all flows)
constraint forall(l in LINKS) (
  sum(f in FLOWS)(FlowOnLink[f,l]) <= Capacity[l]
);

% Flow conservation per flow at each node
constraint forall(f in FLOWS, n in NODES) (
  sum(l in LINKS where EndNode[l] = n)(FlowOnLink[f,l])
  - sum(l in LINKS where StartNode[l] = n)(FlowOnLink[f,l])
  =
  (if n = DestinationNode[f] then DataRate[f]
   elseif n = SourceNode[f] then -DataRate[f]
   else 0 endif)
);

% Total cost
constraint TotalCost = sum(f in FLOWS, l in LINKS)(Cost[l] * FlowOnLink[f,l]);

%--------------------------
% Objective
%--------------------------
solve minimize TotalCost;