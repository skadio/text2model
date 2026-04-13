% Hospital staffing optimization: minimize cost subject to care and staffing limits

var 0..12: doctors;
var 0..12: nurses;

constraint doctors + nurses <= 12;                 % staff limit
constraint 2 * doctors + 3 * nurses >= 10;         % patients treated requirement

var int: total_cost = 5 * doctors + 3 * nurses;

solve minimize total_cost;

output [
  "doctors=", show(doctors), "\n",
  "nurses=", show(nurses), "\n",
  "min_total_cost=", show(total_cost), "\n"
];