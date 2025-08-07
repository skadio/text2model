int: P;                     % number of products
int: M;                     % number of machines

array[1..P] of int: P;      % product sizes (in units of 100 kg)
array[1..M] of int: M;      % machine capacities (in units of 100 kg)

array[1..P, 1..M] of int: P; % production cost per product (per 100 kg)
array[1..P, 1..M] of int: M; % machine cost per product (per 100 kg)
array[1..P, 1..M] of int: P; % time required on machine i for product j (in minutes)