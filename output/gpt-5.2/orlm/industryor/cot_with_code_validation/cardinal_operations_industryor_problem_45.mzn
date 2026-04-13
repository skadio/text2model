% University computer lab staffing (embedded data)

% Parameters
int: S = 6; % students 1..6
int: U = 4; % undergraduates 1..4
set of int: Students = 1..S;
set of int: Undergrads = 1..U;
set of int: Grads = (U+1)..S;

int: D = 5; % Monday..Friday
set of int: Days = 1..D;

int: T = 14; % open hours: 8:00-22:00 => 14 one-hour slots
set of int: Hours = 1..T;

array[Students] of float: wage = [10.0, 10.0, 9.9, 9.8, 10.8, 11.3];

% daily maximum hours each student can work (Mon..Fri)
array[Students, Days] of int: maxDayHours = array2d(Students, Days, [
  6, 0, 6, 0, 7,   % student 1
  0, 8, 9, 6, 0,   % student 2
  4, 8, 3, 0, 5,   % student 3
  5, 5, 6, 0, 4,   % student 4
  3, 0, 5, 8, 0,   % student 5
  0, 6, 0, 6, 5    % student 6
]);

int: minWeeklyU = 8;
int: minWeeklyG = 7;

int: maxShiftsPerStudent = 2; % per week
int: maxStudentsPerDay = 3;   % distinct students per day

% Variables
% assign[s,d,h] = 1 if student s works on day d during hour h
array[Students, Days, Hours] of var 0..1: assign;

% workDay[s,d] = 1 if student s works any hour on day d
array[Students, Days] of var 0..1: workDay;

% hours worked by student s on day d
array[Students, Days] of var 0..T: hoursSD;

% total weekly hours per student
array[Students] of var 0..(D*T): totalHoursS;

% Constraints
% Coverage: exactly one student on duty each open hour
constraint
  forall(d in Days, h in Hours)(
    sum(s in Students)(assign[s,d,h]) = 1
  );

% Daily hours and max daily hours
constraint
  forall(s in Students, d in Days)(
    hoursSD[s,d] = sum(h in Hours)(assign[s,d,h])
  );

constraint
  forall(s in Students, d in Days)(
    hoursSD[s,d] <= maxDayHours[s,d]
  );

% Link workDay <-> hoursSD (workDay is 1 iff any hour worked)
constraint
  forall(s in Students, d in Days)(
    hoursSD[s,d] <= T * workDay[s,d]
  );

constraint
  forall(s in Students, d in Days)(
    workDay[s,d] <= hoursSD[s,d]
  );

% Weekly totals
constraint
  forall(s in Students)(
    totalHoursS[s] = sum(d in Days)(hoursSD[s,d])
  );

% Minimum weekly hours by type
constraint forall(s in Undergrads)( totalHoursS[s] >= minWeeklyU );
constraint forall(s in Grads)( totalHoursS[s] >= minWeeklyG );

% Each student can work no more than 2 shifts per week (shift = day with any work)
constraint
  forall(s in Students)(
    sum(d in Days)(workDay[s,d]) <= maxShiftsPerStudent
  );

% No more than 3 distinct students can be scheduled per day
constraint
  forall(d in Days)(
    sum(s in Students)(workDay[s,d]) <= maxStudentsPerDay
  );

% Objective: minimize total gross pay
var float: totalPay =
  sum(s in Students, d in Days, h in Hours)(
    wage[s] * int2float(assign[s,d,h])
  );

solve minimize totalPay;