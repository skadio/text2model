int: NumLinks;
set of int: Links = 1..NumLinks;

array[Links] of int: StartNode;
array[Links] of int: EndNode;
array[Links] of int: Capacity;
array[Links] of int: Cost;

int: NumFlowReqs;
set of int: Flows = 1..NumFlowReqs;

array[Flows] of int: SourceNode;
array[Flows] of int: DestinationNode;
array[Flows] of int: DataRate;

int: NumNodes =
    max([ max(StartNode), max(EndNode), max(SourceNode), max(DestinationNode) ]);
set of int: Nodes = 1..NumNodes;

int: TotalDemand = sum(DataRate);

array[Flows, Links] of var 0..TotalDemand: x;
array[Links]             of var 0..TotalDemand: load;

constraint
  forall(l in Links)(
    load[l] = sum(f in Flows)( x[f,l] )
  );

constraint
  forall(f in Flows, l in Links)(
    x[f,l] <= Capacity[l]
  );

constraint
  forall(l in Links)(
    load[l] <= Capacity[l]
  );

constraint
  forall(f in Flows, n in Nodes)(
      sum(l in Links where StartNode[l] == n)( x[f,l] )
    - sum(l in Links where EndNode[l]   == n)( x[f,l] )
    =
      ( if n == SourceNode[f] then  DataRate[f]
        elseif n == DestinationNode[f] then -DataRate[f]
        else 0 endif )
  );

solve minimize
  sum(l in Links)( Cost[l] * load[l] );