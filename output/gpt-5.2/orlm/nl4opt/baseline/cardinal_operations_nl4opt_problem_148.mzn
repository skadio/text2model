% Clinical firm production planning: minimize total operating hours

% Data (embedded)
int: inj_north = 800;   % grams/hour anti-itch injections (north)
int: cream_north = 700; % grams/hour topical cream (north)
int: inj_west = 650;    % grams/hour anti-itch injections (west)
int: cream_west = 750;  % grams/hour topical cream (west)

int: plastic_north = 40; % units/hour (north)
int: plastic_west  = 35; % units/hour (west)
int: plastic_avail = 60000;

int: inj_req = 800000;
int: cream_req = 700000;

% Decision variables: hours to run each factory (nonnegative integers)
% Upper bounds from plastic availability
int: max_hours_north = plastic_avail div plastic_north; % 1500
int: max_hours_west  = plastic_avail div plastic_west;  % 1714

var 0..max_hours_north: h_north;
var 0..max_hours_west:  h_west;

% Constraints
constraint inj_north * h_north + inj_west * h_west >= inj_req;
constraint cream_north * h_north + cream_west * h_west >= cream_req;
constraint plastic_north * h_north + plastic_west * h_west <= plastic_avail;

% Objective: minimize total time (sum of factory hours)
solve minimize h_north + h_west;

output [
  "h_north = ", show(h_north), "\n",
  "h_west  = ", show(h_west),  "\n",
  "total_hours = ", show(h_north + h_west), "\n",
  "injections_produced = ", show(inj_north*h_north + inj_west*h_west), " g\n",
  "cream_produced = ", show(cream_north*h_north + cream_west*h_west), " g\n",
  "plastic_used = ", show(plastic_north*h_north + plastic_west*h_west), " units\n"
];