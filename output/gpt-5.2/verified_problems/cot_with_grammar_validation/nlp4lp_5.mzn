% Parameters
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

int: MaxNode = max(
  [max(StartNode), max(EndNode), max(SourceNode), max(DestinationNode)]
);
set of int: NODES = 1..MaxNode;

% Variables
array[FLOWS, LINKS] of var 0..max(Capacity): FlowOnLink;

var 0..(sum(f in FLOWS, l in LINKS)(DataRate[f] * Cost[l])): TotalCost;

% Constraints
constraint
  forall(f in FLOWS, l in LINKS) (
    FlowOnLink[f,l] >= 0
  );

constraint
  forall(l in LINKS) (
    sum(f in FLOWS)(FlowOnLink[f,l]) <= Capacity[l]
  );

constraint
  forall(f in FLOWS, n in NODES) (
    sum(l in LINKS where StartNode[l] = n)(FlowOnLink[f,l])
    - sum(l in LINKS where EndNode[l] = n)(FlowOnLink[f,l])
    =
    (if n = SourceNode[f] then DataRate[f] else 0 endif)
    - (if n = DestinationNode[f] then DataRate[f] else 0 endif)
  );

% Objective
constraint
  TotalCost = sum(f in FLOWS, l in LINKS)(Cost[l] * FlowOnLink[f,l]);

solve minimize TotalCost;