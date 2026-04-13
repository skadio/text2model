% Resource redistribution among cities (min-cost flow)

int: nCities = 5;
set of int: CITIES = 1..nCities;

array[CITIES] of int: initialSupply = [221, 98, 337, 425, 250];
array[CITIES] of int: requiredDemand = [128, 317, 394, 108, 101];

array[CITIES, CITIES] of int: transportCost =
  [|  0, 20, 39,  4, 45
   |  1,  0,  8, 23, 44
   |  5, 46,  0, 36, 15
   |  3,  5, 10,  0, 27
   | 37, 15,  7, 45,  0 |];

int: maxShip = sum(initialSupply);
array[CITIES, CITIES] of var 0..maxShip: ship;

var 0..(max(transportCost) * sum(initialSupply)): totalCost;

% No self shipping
constraint forall(i in CITIES)( ship[i,i] = 0 );

% Outgoing from each city cannot exceed its initial supply
constraint forall(i in CITIES)(
  sum(j in CITIES)( ship[i,j] ) <= initialSupply[i]
);

% Each city must end with at least its required demand
constraint forall(k in CITIES)(
  initialSupply[k]
  + sum(i in CITIES)( ship[i,k] )
  - sum(j in CITIES)( ship[k,j] )
  >= requiredDemand[k]
);

% Total cost
constraint totalCost =
  sum(i in CITIES, j in CITIES)( ship[i,j] * transportCost[i,j] );

solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "ship =\n",
  concat([ concat([ if j=1 then "" else " " endif ++ show(ship[i,j])
                    | j in CITIES ]) ++ "\n"
          | i in CITIES ])
];