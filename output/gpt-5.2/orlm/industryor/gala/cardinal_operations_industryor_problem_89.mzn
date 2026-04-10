% Promotional packages optimization (embedded data)

% Data
int: shirts_available = 200;
int: pants_available  = 100;

% Package composition
int: shirts_A = 1;
int: pants_A  = 2;
int: price_A  = 30;

int: shirts_B = 3;
int: pants_B  = 1;
int: price_B  = 50;

% Minimum sales requirements
int: min_A = 20;
int: min_B = 10;

% Decision variables: number of packages sold
var min_A..shirts_available: A;
var min_B..shirts_available: B;

% Resource constraints
constraint shirts_A * A + shirts_B * B <= shirts_available;
constraint pants_A  * A + pants_B  * B <= pants_available;

% Objective: maximize revenue
var int: revenue = price_A * A + price_B * B;

solve maximize revenue;

output [
  "A = ", show(A), "\n",
  "B = ", show(B), "\n",
  "Revenue = ", show(revenue), "\n",
  "Shirts used = ", show(shirts_A * A + shirts_B * B), " / ", show(shirts_available), "\n",
  "Pants used = ", show(pants_A * A + pants_B * B), " / ", show(pants_available), "\n"
];