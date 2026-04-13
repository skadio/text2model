% Hospital staffing allocation: minimize total cost

var 0..100: doctors;
var 0..100: nurses;
var 0..100: technicians;

int: cost_doctor = 10;
int: cost_nurse = 20;
int: cost_technician = 30;

constraint 2 * doctors + 3 * nurses >= 50;
constraint doctors + nurses + technicians <= 100;
constraint technicians - nurses >= 10;

var int: total_cost = cost_doctor * doctors + cost_nurse * nurses + cost_technician * technicians;

solve minimize total_cost;

output [
  "doctors=", show(doctors), "\n",
  "nurses=", show(nurses), "\n",
  "technicians=", show(technicians), "\n",
  "total_cost=", show(total_cost), "\n"
];