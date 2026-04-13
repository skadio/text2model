int: shirts_available = 200;
int: pants_available  = 100;

int: priceA = 30;
int: priceB = 50;

int: minA = 20;
int: minB = 10;

% Decision variables: number of packages to sell
var minA..shirts_available: A;   % at least minA, bounded for safety
var minB..shirts_available: B;   % at least minB, bounded for safety

% Resource constraints
constraint A + 3*B <= shirts_available;   % shirts used
constraint 2*A + B <= pants_available;    % pants used

% Objective: maximize revenue
var int: revenue = priceA*A + priceB*B;
solve maximize revenue;

output [
  "A = ", show(A), "\n",
  "B = ", show(B), "\n",
  "Revenue = ", show(revenue), "\n"
];