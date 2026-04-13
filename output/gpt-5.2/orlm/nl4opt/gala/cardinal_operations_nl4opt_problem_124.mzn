% Gem factory drill planning (all data embedded)

% Data
int: gems_required = 800;
int: water_available = 700;

int: hi_gems = 50;
int: hi_water = 50;

int: lo_gems = 30;
int: lo_water = 20;

float: max_hi_fraction = 0.40;  % at most 40% high intensity
int: min_lo = 10;               % at least 10 low intensity

% Decision variables: number of drills of each type
var 0..1000: hi;  % high intensity drills
var 0..1000: lo;  % low intensity drills

var 0..2000: total = hi + lo;

% Constraints
constraint hi * hi_gems + lo * lo_gems >= gems_required;
constraint hi * hi_water + lo * lo_water <= water_available;

constraint lo >= min_lo;

% "At most 40% of the drills can be high intensity"
% hi / (hi+lo) <= 0.4  <=>  5*hi <= 2*(hi+lo)  <=>  3*hi <= 2*lo
constraint 3 * hi <= 2 * lo;

% Objective: minimize total number of drills
solve minimize total;

output [
  "high_intensity = ", show(hi), "\n",
  "low_intensity  = ", show(lo), "\n",
  "total_drills   = ", show(total), "\n",
  "gems_processed = ", show(hi*hi_gems + lo*lo_gems), "\n",
  "water_used     = ", show(hi*hi_water + lo*lo_water), "\n"
];