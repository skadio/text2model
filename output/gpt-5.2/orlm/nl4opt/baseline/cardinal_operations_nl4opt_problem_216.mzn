int: total_acres = 300;

int: oil_small = 2;      % barrels per acre
int: oil_large = 5;      % barrels per acre

int: poll_small = 10;    % units per acre
int: poll_large = 20;    % units per acre
int: poll_limit = 4500;

int: bits_small = 5;     % drill bits per acre
int: bits_large = 10;    
int: bits_available = 2500;

var 0..total_acres: acres_small;
var 0..total_acres: acres_large;

constraint acres_small + acres_large <= total_acres;
constraint poll_small * acres_small + poll_large * acres_large <= poll_limit;
constraint bits_small * acres_small + bits_large * acres_large <= bits_available;

var int: total_oil = oil_small * acres_small + oil_large * acres_large;

solve maximize total_oil;

output [
  "acres_small=", show(acres_small), "\n",
  "acres_large=", show(acres_large), "\n",
  "total_oil=", show(total_oil), "\n"
];