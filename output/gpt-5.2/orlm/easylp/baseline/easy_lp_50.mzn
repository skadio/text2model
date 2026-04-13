% Hospital staff allocation optimization
% Minimize daily cost subject to staffing and requirement constraints.

var 0..1000: doctors;
var 0..1000: nurses;

constraint doctors + nurses >= 20;
constraint abs(2 * doctors - nurses) <= 10;

var int: total_cost = 10 * doctors + 5 * nurses;

solve minimize total_cost;

output [
  "doctors = ", show(doctors), "\n",
  "nurses = ", show(nurses), "\n",
  "min_cost_per_day = $", show(total_cost), "\n"
];