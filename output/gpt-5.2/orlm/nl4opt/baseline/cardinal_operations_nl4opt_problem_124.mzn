% Gem factory drill planning (all data embedded)

int: gems_required = 800;
int: water_available = 700;

int: hi_gems = 50;
int: hi_water = 50;

int: lo_gems = 30;
int: lo_water = 20;

float: max_hi_fraction = 0.40;
int: min_lo_drills = 10;

% Decision variables: number of drills of each type (nonnegative integers)
var 0..1000: hi;
var 0..1000: lo;

% Total drills
var 0..2000: total = hi + lo;

constraint
  % Must process at least required gems
  hi_gems * hi + lo_gems * lo >= gems_required /\
  % Water limit
  hi_water * hi + lo_water * lo <= water_available /\
  % At most 40% high intensity:
  % hi <= 0.4 * (hi+lo)  <=>  5*hi <= 2*(hi+lo)  <=>  3*hi <= 2*lo
  3 * hi <= 2 * lo /\
  % At least 10 low intensity drills
  lo >= min_lo_drills;

solve minimize total;

output [
  "high_intensity_drills = ", show(hi), "\n",
  "low_intensity_drills  = ", show(lo), "\n",
  "total_drills          = ", show(total), "\n",
  "gems_processed        = ", show(hi_gems*hi + lo_gems*lo), "\n",
  "water_used            = ", show(hi_water*hi + lo_water*lo), "\n"
];