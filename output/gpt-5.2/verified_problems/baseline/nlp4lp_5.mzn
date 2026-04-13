include "globals.mzn";

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

int: NumNodes = max(
  max([StartNode[l] | l in LINKS] ++ [EndNode[l] | l in LINKS]),
  max([SourceNode[f] | f in FLOWS] ++ [DestinationNode[f] | f in FLOWS])
);
set of int: NODES = 1..NumNodes;

array[FLOWS, LINKS] of var 0..max(Capacity): FlowOnLink;

constraint
  forall(l in LINKS) (
    sum(f in FLOWS)(FlowOnLink[f,l]) <= Capacity[l]
  );

constraint
  forall(f in FLOWS, n in NODES) (
    sum(l in LINKS where EndNode[l] = n)(FlowOnLink[f,l]) -
    sum(l in LINKS where StartNode[l] = n)(FlowOnLink[f,l])
    =
    (if n = DestinationNode[f] then DataRate[f] else 0 endif) -
    (if n = SourceNode[f] then DataRate[f] else 0 endif)
  );

var int: TotalCost = sum(f in FLOWS, l in LINKS)(Cost[l] * FlowOnLink[f,l]);

solve minimize TotalCost;

output [
  "TotalCost = ", show(TotalCost), "\n",
  "FlowOnLink[f,l]:\n"
] ++
[
  "f=" ++ show(f) ++ ": " ++
  show([ FlowOnLink[f,l] | l in LINKS ]) ++ "\n"
  | f in FLOWS
];