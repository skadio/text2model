% Hospital staffing optimization (all data embedded)

int: cost_doctor = 10;
int: cost_nurse  = 20;

int: min_total_staff = 50;        % doctors + nurses >= 50
int: max_weighted_staff = 120;    % 2*doctors + nurses <= 120

var 0..max_weighted_staff: doctors;
var 0..max_weighted_staff: nurses;

constraint doctors + nurses >= min_total_staff;
constraint 2*doctors + nurses <= max_weighted_staff;

var int: total_cost = cost_doctor * doctors + cost_nurse * nurses;

solve minimize total_cost;

output [
  "doctors=", show(doctors), "\n",
  "nurses=", show(nurses), "\n",
  "min_total_cost=", show(total_cost), "\n"
];