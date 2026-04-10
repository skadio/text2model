% Parameters
int: gems_required = 800;
int: water_available = 700;

int: hi_gems_per_drill = 50;
int: hi_water_per_drill = 50;

int: lo_gems_per_drill = 30;
int: lo_water_per_drill = 20;

float: hi_fraction_max = 0.40;
int: lo_min = 10;

% Variables
var 0..gems_required: hi;
var lo_min..gems_required: lo;
var 0..2*gems_required: total_drills = hi + lo;

% Constraints
constraint hi * hi_gems_per_drill + lo * lo_gems_per_drill >= gems_required;
constraint hi * hi_water_per_drill + lo * lo_water_per_drill <= water_available;

% at most 40% high intensity: hi <= 0.4*(hi+lo)  <=>  3*hi <= 2*lo
constraint 3 * hi <= 2 * lo;

% Objective
solve minimize total_drills;