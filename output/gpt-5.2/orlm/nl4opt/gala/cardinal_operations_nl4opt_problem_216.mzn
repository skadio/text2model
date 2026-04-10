% Oil well land-allocation optimization (all data embedded)

% Data
int: total_land = 300;

int: oil_small = 2;        % barrels per acre
int: oil_large = 5;

int: poll_small = 10;      % pollution units per acre
int: poll_large = 20;

int: bits_small = 5;       % drill bits per acre
int: bits_large = 10;

int: bits_avail = 2500;
int: poll_max = 4500;

% Decision variables: acres allocated to each well type
var 0..total_land: acres_small;
var 0..total_land: acres_large;

% Constraints
constraint acres_small + acres_large <= total_land;
constraint bits_small * acres_small + bits_large * acres_large <= bits_avail;
constraint poll_small * acres_small + poll_large * acres_large <= poll_max;

% Objective: maximize total oil production
var int: total_oil = oil_small * acres_small + oil_large * acres_large;

solve maximize total_oil;

output [
  "Acres small = ", show(acres_small), "\n",
  "Acres large = ", show(acres_large), "\n",
  "Total oil (barrels) = ", show(total_oil), "\n",
  "Drill bits used = ", show(bits_small * acres_small + bits_large * acres_large), " / ", show(bits_avail), "\n",
  "Pollution produced = ", show(poll_small * acres_small + poll_large * acres_large), " / ", show(poll_max), "\n"
];