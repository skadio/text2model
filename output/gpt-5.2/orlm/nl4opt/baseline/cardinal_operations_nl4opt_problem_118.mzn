% Fish transport: minimize total time with helicopter/car trips

int: fish_required = 300;

int: cap_heli = 30;
int: time_heli = 40;

int: cap_car = 20;
int: time_car = 30;

int: max_heli_trips = 5;

% At least 60% of trips by car: car_trips / (car_trips + heli_trips) >= 0.6
% Equivalent: 5*car_trips >= 3*(car_trips + heli_trips) -> 2*car_trips >= 3*heli_trips

var 0..max_heli_trips: heli_trips;
var 0..1000: car_trips;

constraint cap_heli * heli_trips + cap_car * car_trips >= fish_required;
constraint 2 * car_trips >= 3 * heli_trips;

var int: total_time = time_heli * heli_trips + time_car * car_trips;

solve minimize total_time;

output [
  "helicopter_trips=", show(heli_trips), "\n",
  "car_trips=", show(car_trips), "\n",
  "fish_moved=", show(cap_heli * heli_trips + cap_car * car_trips), "\n",
  "total_trips=", show(heli_trips + car_trips), "\n",
  "total_time_minutes=", show(total_time), "\n"
];