% Computer lab staffing with weekly/hourly schedule
% 8:00-22:00 => 14 one-hour slots per day, Mon-Fri (5 days)
% Exactly one student on duty each open hour.
% Each student has a daily maximum hours availability (Table 5-9).
% Undergrads (1..4) must work >= 8 hours/week; grads (5..6) >= 7 hours/week.
% Additional requirements:
% - each student can work no more than 2 shifts per week
% - no more than 3 students can be scheduled each day
% Objective: minimize total wage cost.

include "globals.mzn";

int: N = 6;
int: D = 5;
int: S = 14; % hourly slots per day

set of int: Students = 1..N;
set of int: Days = 1..D;
set of int: Slots = 1..S;

set of int: Undergrads = 1..4;
set of int: Grads = 5..6;

% Scale wages by 10 to avoid floating point
% wages: [10.0, 10.0, 9.9, 9.8, 10.8, 11.3] CNY/h
array[Students] of int: wage10 = [100, 100, 99, 98, 108, 113];

% Daily max hours availability from Table 5-9
% order: Mon, Tue, Wed, Thu, Fri
array[Students, Days] of int: avail =
  array2d(Students, Days,
  [
    6, 0, 6, 0, 7,  % student 1
    0, 8, 9, 6, 0,  % student 2
    4, 8, 3, 0, 5,  % student 3
    5, 5, 6, 0, 4,  % student 4
    3, 0, 5, 8, 0,  % student 5
    0, 6, 0, 6, 5   % student 6
  ]);

% Decision: x[s,d,t] = 1 if student s works hour-slot t on day d
array[Students, Days, Slots] of var 0..1: x;

% Derived: hours per student per day, and per week
array[Students, Days] of var 0..S: hsd =
  array2d(Students, Days, [sum(t in Slots)(x[s,d,t]) | s in Students, d in Days]);

array[Students] of var 0..(D*S): hw = [sum(d in Days)(hsd[s,d]) | s in Students];

% Exactly one student on duty each hour-slot
constraint
  forall(d in Days, t in Slots) (
    sum(s in Students)(x[s,d,t]) = 1
  );

% Respect daily maximum availability hours
constraint
  forall(s in Students, d in Days) (
    hsd[s,d] <= avail[s,d]
  );

% Weekly minimum hours requirements
constraint forall(s in Undergrads)(hw[s] >= 8);
constraint forall(s in Grads)(hw[s] >= 7);

% Daily limit: no more than 3 distinct students scheduled per day
array[Students, Days] of var 0..1: used_day;
constraint
  forall(s in Students, d in Days) (
    used_day[s,d] = bool2int(hsd[s,d] >= 1)
  );
constraint
  forall(d in Days) (
    sum(s in Students)(used_day[s,d]) <= 3
  );

% Shifts:
% Define a shift as a maximal consecutive block of working hours for a student on a day.
% Count shift starts; total shift starts over the week <= 2 for each student.
array[Students, Days, Slots] of var 0..1: start;
constraint
  forall(s in Students, d in Days) (
    start[s,d,1] = x[s,d,1]
  );
constraint
  forall(s in Students, d in Days, t in 2..S) (
    start[s,d,t] >= x[s,d,t] - x[s,d,t-1] /\
    start[s,d,t] <= x[s,d,t] /\
    start[s,d,t] <= 1 - x[s,d,t-1]
  );

constraint
  forall(s in Students) (
    sum(d in Days, t in Slots)(start[s,d,t]) <= 2
  );

% Objective: minimize total wage cost (scaled by 10)
var int: total_cost10 = sum(s in Students, d in Days, t in Slots)(wage10[s] * x[s,d,t]);

solve minimize total_cost10;

output [
  "Total cost (CNY): ", show(total_cost10 / 10.0), "\n\n",
  "Weekly hours per student:\n",
  concat([ "Student ", show(s), ": ", show(hw[s]), " h\n" | s in Students ]),
  "\nHours per day (Mon..Fri):\n",
  concat([
    "Student " ++ show(s) ++ ": " ++
    concat([ show(hsd[s,d]) ++ (if d < D then " " else "" endif) | d in Days ]) ++ "\n"
    | s in Students
  ])
];