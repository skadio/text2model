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

% Derived parameters
int: NumNodes = max(
  [ max(StartNode[l], EndNode[l]) | l in LINKS ] ++
  [ max(SourceNode[f], DestinationNode[f]) | f in FLOWS ]
);
set of int: NODES = 1..NumNodes;

% Variables
array[FLOWS, LINKS] of var 0..max(Capacity): FlowOnLink;

var int: TotalCost;

% Constraints
constraint
  forall(f in FLOWS, l in LINKS) (
    FlowOnLink[f,l] >= 0 /\ FlowOnLink[f,l] <= Capacity[l]
  );

constraint
  forall(l in LINKS) (
    sum(f in FLOWS)(FlowOnLink[f,l]) <= Capacity[l]
  );

constraint
  forall(f in FLOWS, n in NODES) (
    sum(l in LINKS where EndNode[l] = n)(FlowOnLink[f,l]) -
    sum(l in LINKS where StartNode[l] = n)(FlowOnLink[f,l])
    =
    (if n = DestinationNode[f] then DataRate[f]
     elseif n = SourceNode[f] then -DataRate[f]
     else 0 endif)
  );

% Objective
constraint
  TotalCost = sum(f in FLOWS, l in LINKS)(Cost[l] * FlowOnLink[f,l]);

solve minimize TotalCost;