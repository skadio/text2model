% Parameters (with values embedded)
int: min_people = 550;
int: cap_kayak = 4;
int: cap_motor = 5;
int: time_kayak = 5;   % minutes per trip
int: time_motor = 3;   % minutes per trip
int: max_motor_trips = 25;
int: kayak_share_num = 75;  % at least 75% trips are kayak

% Upper bounds for search (safe, derived from requirements)
int: max_total_trips = ceil(int2float(min_people) / min(cap_kayak, cap_motor)); % <= 138
int: max_kayak_trips = max_total_trips;

% Variables
var 0..max_kayak_trips: kayak_trips;
var 0..max_motor_trips: motor_trips;
var 0..(time_kayak * max_kayak_trips + time_motor * max_motor_trips): total_time;

% Constraints
constraint cap_kayak * kayak_trips + cap_motor * motor_trips >= min_people;

% At most 25 motorboat trips is enforced by variable bound, restated for clarity
constraint motor_trips <= max_motor_trips;

% At least 75% of trips should be by kayak:
% kayak_trips / (kayak_trips + motor_trips) >= 0.75
% => 4*kayak_trips >= 3*(kayak_trips + motor_trips) => kayak_trips >= 3*motor_trips
constraint kayak_trips >= 3 * motor_trips;

% Define total time
constraint total_time = time_kayak * kayak_trips + time_motor * motor_trips;

% Objective
solve minimize total_time;

output [
  "kayak_trips = ", show(kayak_trips), "\n",
  "motor_trips = ", show(motor_trips), "\n",
  "total_people_moved = ", show(cap_kayak * kayak_trips + cap_motor * motor_trips), "\n",
  "total_time = ", show(total_time), " minutes\n"
];