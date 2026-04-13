int: doctor_hours = 4;
int: nurse_hours  = 6;

var 0..1000: doctors;
var 0..1000: nurses;

constraint 2 * doctors * doctor_hours + 3 * nurses * nurse_hours >= 10;
constraint 5 * doctors * doctor_hours + 1 * nurses * nurse_hours <= 20;

var 0..1000000: total_hours = doctors * doctor_hours + nurses * nurse_hours;

solve minimize total_hours;

output [
  "doctors=", show(doctors), "\n",
  "nurses=", show(nurses), "\n",
  "total_hours=", show(total_hours), "\n"
];