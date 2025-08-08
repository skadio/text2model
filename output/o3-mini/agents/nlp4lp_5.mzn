include "globals.mzn";

/* Input parameters */
int: NumLinks;
array[1..NumLinks] of int: StartNode;
array[1..NumLinks] of int: EndNode;
array[1..NumLinks] of int: Capacity;
array[1..NumLinks] of int: Cost;

int: NumFlowReqs;
array[1..NumFlowReqs] of int: SourceNode;
array[1..NumFlowReqs] of int: DestinationNode;
array[1..NumFlowReqs] of int: DataRate;

/* Determine the set of nodes.
   We assume that all nodes appearing in StartNode, EndNode, SourceNode and DestinationNode
   are part of the network. */
int: n1 = max(max(StartNode), max(EndNode));
int: n2 = max(max(SourceNode), max(DestinationNode));
int: numNodes = if n1 > n2 then n1 else n2 endif;

/* Decision variables:
   flow[l,f] is the amount of data from flow requirement f routed over link l.
   For each link l and each flow f, the flow amount cannot exceed DataRate[f] (the entire demand)
   while the sum over flows on a link must not exceed that link’s Capacity.
*/
array[1..NumLinks, 1..NumFlowReqs] of var int: flow;

/* Flow conservation constraints.
   For each flow requirement f and for every node in the network, 
   we require that:
      ∑(links ending at node) flow[l,f] - ∑(links starting at node) flow[l,f] =
         DataRate[f] if node is the destination of flow f,
        -DataRate[f] if node is the source of flow f,
         0 otherwise.
*/
constraint
  forall(f in 1..NumFlowReqs, node in 1..numNodes) (
    sum(l in 1..NumLinks where EndNode[l] = node)( flow[l,f] )
   - sum(l in 1..NumLinks where StartNode[l] = node)( flow[l,f] )
   =
     if node = DestinationNode[f] then DataRate[f]
     else if node = SourceNode[f] then -DataRate[f]
     else 0
     endif endif
  );

/* Link capacity constraints:
   For each link, the sum of all flows traversing that link cannot exceed its Capacity.
*/
constraint
  forall(l in 1..NumLinks) (
    sum(f in 1..NumFlowReqs)( flow[l,f] ) <= Capacity[l]
  );

/* Optional: For each flow, one cannot send more than its total demand on any given link. */
constraint
  forall(l in 1..NumLinks, f in 1..NumFlowReqs)(
    flow[l,f] <= DataRate[f]
  );

/* Objective: Minimize the total cost.
   The cost is given by the per-unit Cost on each link multiplied by the amount of data 
   sent through that link (summed over all flows).
*/
var int: totalCost = sum(l in 1..NumLinks, f in 1..NumFlowReqs)( Cost[l] * flow[l,f] );

solve minimize totalCost;

output [
  "TotalCost = ", show(totalCost), "\n",
  "Flow on each link (indexed by flow requirement):\n",
  concat([ "Link " ++ show(l) ++ ": " ++ show([ flow[l,f] | f in 1..NumFlowReqs ]) ++ "\n" | l in 1..NumLinks ])
];