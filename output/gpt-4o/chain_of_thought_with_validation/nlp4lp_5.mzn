int: NumLinks;
int: NumFlowReqs;

array[1..NumLinks] of int: StartNode;
array[1..NumLinks] of int: EndNode;
array[1..NumLinks] of int: Capacity;
array[1..NumLinks] of int: Cost;

array[1..NumFlowReqs] of int: SourceNode;
array[1..NumFlowReqs] of int: DestinationNode;
array[1..NumFlowReqs] of int: DataRate;

set of int: Links = 1..NumLinks;
set of int: Flows = 1..NumFlowReqs;
set of int: Nodes =
        { StartNode[l] | l in Links }
      union { EndNode[l] | l in Links }
      union { SourceNode[f] | f in Flows }
      union { DestinationNode[f] | f in Flows };

int: MaxCapacity = max(Capacity);

array[Links, Flows] of var 0..MaxCapacity: flow;
var int: TotalCost;

constraint
  forall(l in Links)(
    sum(f in Flows)(flow[l,f]) <= Capacity[l]
);

constraint
  forall(f in Flows, n in Nodes)(
    sum(l in Links where StartNode[l] == n)(flow[l,f]) -
    sum(l in Links where EndNode[l]   == n)(flow[l,f])
    =
    if n == SourceNode[f] then  DataRate[f]
    elseif n == DestinationNode[f] then -DataRate[f]
    else 0
    endif
);

constraint
  TotalCost = sum(l in Links, f in Flows)(flow[l,f] * Cost[l]);

solve minimize TotalCost;