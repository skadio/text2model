% Network optimization: minimize resource cost
% Variables:
%   b = integer units of bandwidth improvement (>=0)
%   l = integer units of latency reduction (>=0)

var 0..1000: b;
var 0..1000: l;

% Resource cost: 5 per unit bandwidth improvement, 10 per unit latency reduction
var int: cost = 5*b + 10*l;

% Constraints:
% 1) 2*b + l >= 200
% 2) 3*b + l <= 500
constraint 2*b + l >= 200;
constraint 3*b + l <= 500;

solve minimize cost;

output [
  "bandwidth_improvement=", show(b), "\n",
  "latency_reduction=", show(l), "\n",
  "min_total_resource_cost=", show(cost), "\n"
];