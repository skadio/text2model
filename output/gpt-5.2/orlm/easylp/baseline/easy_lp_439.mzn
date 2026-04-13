% Hospital staffing allocation: Doctors and Nurses
% Minimize total cost: 5 per Doctor, 3 per Nurse

var 0..200: doctors;
var 0..200: nurses;

constraint 2 * doctors + nurses >= 50;
constraint doctors + 3 * nurses <= 100;
constraint doctors >= nurses + 10;

var int: total_cost = 5 * doctors + 3 * nurses;

solve minimize total_cost;

output [
  "Doctors = ", show(doctors), "\n",
  "Nurses = ", show(nurses), "\n",
  "Minimum total staffing cost = ", show(total_cost), "\n"
];