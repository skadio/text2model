% Printer purchasing optimization (all data embedded)

% Data
int: ppm_premium = 30;
int: ppm_regular = 20;

int: ink_premium = 4;
int: ink_regular = 3;

int: min_pages = 200;
int: max_ink = 35;

% Decision variables: number of printers of each type
var 0..100: premium;
var 0..100: regular;

% Constraints
constraint ppm_premium * premium + ppm_regular * regular >= min_pages;
constraint ink_premium * premium + ink_regular * regular <= max_ink;

% Regular printers must be fewer than premium printers
constraint regular < premium;

% Objective: minimize total number of printers
var 0..200: total = premium + regular;
solve minimize total;

output [
  "premium = ", show(premium), "\n",
  "regular  = ", show(regular), "\n",
  "total    = ", show(total), "\n",
  "pages_per_min = ", show(ppm_premium * premium + ppm_regular * regular), "\n",
  "ink_per_min   = ", show(ink_premium * premium + ink_regular * regular), "\n"
];