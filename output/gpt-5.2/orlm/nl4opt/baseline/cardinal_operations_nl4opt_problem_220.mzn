% Lake evacuation: minimize total transport time

int: people_needed = 550;

% Capacities per trip
int: cap_kayak = 4;
int: cap_motor = 5;

% Time per trip (minutes)
int: time_kayak = 5;
int: time_motor = 3;

% Limits / policy
int: max_motor_trips = 25;
int: kayak_share_num = 75; % percent
int: kayak_share_den = 100;

% Decision variables: number of trips
var 0..ceil(people_needed / min(cap_kayak, cap_motor)) + max_motor_trips: K; % kayak trips
var 0..max_motor_trips: M;                                                   % motorboat trips

% Total time
var int: total_time = time_kayak * K + time_motor * M;

constraint cap_kayak * K + cap_motor * M >= people_needed;
constraint M <= max_motor_trips;

% At least 75% of trips are by kayak: K/(K+M) >= 0.75
% Cross-multiply to avoid fractions: 100*K >= 75*(K+M)  -> 25*K >= 75*M -> K >= 3*M
constraint kayak_share_den * K >= kayak_share_num * (K + M);

solve minimize total_time;

output [
  "kayak_trips=", show(K), "\n",
  "motorboat_trips=", show(M), "\n",
  "people_moved=", show(cap_kayak*K + cap_motor*M), "\n",
  "total_time_minutes=", show(total_time), "\n"
];