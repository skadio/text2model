% Car shipment with large and small planes

int: large_capacity = 30;
int: small_capacity = 10;
int: demand = 300;

% Decision variables: number of each plane type
var 0..demand div large_capacity + 10: L; % large planes
var 0..demand div small_capacity + 10: S; % small planes

% Total planes
var 0..1000: total_planes = L + S;

constraint large_capacity * L + small_capacity * S >= demand;
constraint L < S;

solve minimize total_planes;

output [
  "Large planes: ", show(L), "\n",
  "Small planes: ", show(S), "\n",
  "Total planes: ", show(total_planes), "\n",
  "Cars delivered: ", show(large_capacity * L + small_capacity * S), "\n"
];