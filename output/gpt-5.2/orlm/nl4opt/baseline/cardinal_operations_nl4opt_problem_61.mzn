% Printers purchase optimization (all data embedded)

int: pages_premium = 30;
int: pages_regular = 20;

int: ink_premium = 4;
int: ink_regular = 3;

int: min_pages = 200;
int: max_ink = 35;

% Decision variables: number of printers (nonnegative integers)
var 0..100: premium;
var 0..100: regular;

% Constraints
constraint pages_premium * premium + pages_regular * regular >= min_pages;
constraint ink_premium * premium + ink_regular * regular <= max_ink;
constraint regular < premium;

% Objective: minimize total number of printers
var 0..200: total_printers = premium + regular;
solve minimize total_printers;

output [
  "premium=", show(premium), "\n",
  "regular=", show(regular), "\n",
  "total_printers=", show(total_printers), "\n"
];