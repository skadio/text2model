% Parameters (with values embedded)
int: shirts_available = 200;
int: pants_available  = 100;

int: price_A = 30;   % £ per package A
int: price_B = 50;   % £ per package B

int: shirts_in_A = 1;
int: pants_in_A  = 2;

int: shirts_in_B = 3;
int: pants_in_B  = 1;

int: min_A = 20;
int: min_B = 10;

% Variables
var min_A..shirts_available: A;  % number of package A
var min_B..shirts_available: B;  % number of package B

% Constraints
constraint shirts_in_A * A + shirts_in_B * B <= shirts_available;
constraint pants_in_A  * A + pants_in_B  * B <= pants_available;

% Objective
solve maximize price_A * A + price_B * B;

output [
  "A = ", show(A), "\n",
  "B = ", show(B), "\n",
  "Revenue = ", show(price_A * A + price_B * B), "\n"
];