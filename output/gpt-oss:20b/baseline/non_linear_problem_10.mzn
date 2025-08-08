int: ndepts;
int: ncities;
int: ncitiesm1;
array[1..ndepts, 1..ncities] of int: benefit;
array[1..ncities, 1..ncities] of int: dist;
array[1..ndepts, 1..ndepts] of int: comm;

var 1..ncities: city[1..ndepts];

constraint
  forall(c in 1..ncities) (
    sum(d in 1..ndepts) (city[d] == c) <= 3
  );

var int: benefit_sum = sum(d in 1..ndepts) benefit[d, city[d]];
var int: comm_cost = sum(i in 1..ndepts-1, j in i+1..ndepts) comm[i,j] * dist[city[i], city[j]];

solve maximize benefit_sum - comm_cost;

output [
  "Assignments: ", show(city), "\n",
  "Total Benefit: ", show(benefit_sum), "\n",
  "Total Communication Cost: ", show(comm_cost), "\n",
  "Net Savings: ", show(benefit_sum - comm_cost), "\n"
];