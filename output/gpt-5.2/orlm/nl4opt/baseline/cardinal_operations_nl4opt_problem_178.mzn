% Hand sanitizer machines purchase optimization

% Data (embedded)
int: drops_motion = 50;
int: drops_manual = 75;

int: kwh_motion = 30;
int: kwh_manual = 20;

int: min_total_drops = 1000;
int: max_total_kwh = 500;

int: min_motion = 3;
% At most 40% manual: manual <= 0.4 * total  <=> 5*manual <= 2*total
int: manual_ratio_num = 2;
int: manual_ratio_den = 5;

% Decision variables (upper bounds chosen safely from constraints)
% From energy: 20*m <= 500 => m <= 25; 30*x <= 500 => x <= 16
var 0..16: motion;
var 0..25: manual;

var 0..100: total = motion + manual;

% Constraints
constraint 5 * manual <= 2 * total;              % manual <= 40% of total
constraint motion >= min_motion;

constraint drops_motion * motion + drops_manual * manual >= min_total_drops;
constraint kwh_motion * motion + kwh_manual * manual <= max_total_kwh;

% Objective: minimize number of machines
solve minimize total;

output [
  "motion=", show(motion), "\n",
  "manual=", show(manual), "\n",
  "total=", show(total), "\n",
  "drops_per_min=", show(drops_motion * motion + drops_manual * manual), "\n",
  "kwh_per_min=", show(kwh_motion * motion + kwh_manual * manual), "\n"
];