% Parameters

int: nStudents = 6;                    % total students
set of int: STUDENTS = 1..nStudents;

int: nDays = 5;                        % Monday..Friday
set of int: DAYS = 1..nDays;

% Lab open hours: 8:00 to 22:00 => 14 hours per day (treated as 14 one-hour slots)
int: hoursPerDay = 14;
set of int: HOURS = 1..hoursPerDay;

% Student types
set of int: UNDERGRADS = 1..4;
set of int: GRADS = 5..6;

% Wages (CNY per hour)
array[STUDENTS] of float: wage =
  [10.0, 10.0, 9.9, 9.8, 10.8, 11.3];

% Maximum duty hours available per student per day (Mon..Fri)
% day index: 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri
array[STUDENTS, DAYS] of int: maxHours =
  array2d(STUDENTS, DAYS,
  [ 6, 0, 6, 0, 7,   % student 1
    0, 8, 9, 6, 0,   % student 2
    4, 8, 3, 0, 5,   % student 3
    5, 5, 6, 0, 4,   % student 4
    3, 0, 5, 8, 0,   % student 5
    0, 6, 0, 6, 5    % student 6
  ]);

% Minimum weekly hours requirements
int: minWeeklyUG = 8;                  % each undergraduate at least 8 hours/week
int: minWeeklyGrad = 7;                % each graduate at least 7 hours/week

% Additional scheduling requirements
int: maxShiftsPerWeek = 2;             % each student <= 2 shifts/week (shift = day worked)
int: maxStudentsPerDay = 3;            % <= 3 distinct students scheduled per day


% Variables

% x[s,d,h] = 1 if student s is on duty during hour h of day d, else 0
array[STUDENTS, DAYS, HOURS] of var 0..1: x;

% worksDay[s,d] = 1 if student s works any hour on day d (used for shifts/day counting)
array[STUDENTS, DAYS] of var 0..1: worksDay;

% hoursDay[s,d] = total hours student s works on day d
array[STUDENTS, DAYS] of var 0..hoursPerDay: hoursDay;

% hoursWeek[s] = total hours student s works during the week
array[STUDENTS] of var 0..(nDays * hoursPerDay): hoursWeek;

% studentsUsedDay[d] = number of distinct students working at least one hour on day d
array[DAYS] of var 0..nStudents: studentsUsedDay;

% total gross pay to minimize
var float: totalPay;


% Constraints

% Link daily hours to hourly assignment decisions
constraint
  forall(s in STUDENTS, d in DAYS) (
    hoursDay[s,d] = sum(h in HOURS)(x[s,d,h])
  );

% Link weekly hours to daily hours
constraint
  forall(s in STUDENTS) (
    hoursWeek[s] = sum(d in DAYS)(hoursDay[s,d])
  );

% Lab coverage: exactly one student on duty for every open hour
constraint
  forall(d in DAYS, h in HOURS) (
    sum(s in STUDENTS)(x[s,d,h]) = 1
  );

% Respect each student's maximum available duty hours per day
constraint
  forall(s in STUDENTS, d in DAYS) (
    hoursDay[s,d] <= maxHours[s,d]
  );

% Define whether a student works on a given day (used for shift counting)
constraint
  forall(s in STUDENTS, d in DAYS) (
    worksDay[s,d] <= hoursDay[s,d]
  )
  /\
  forall(s in STUDENTS, d in DAYS) (
    hoursDay[s,d] <= hoursPerDay * worksDay[s,d]
  );

% Minimum weekly hours by student type
constraint
  forall(s in UNDERGRADS) (
    hoursWeek[s] >= minWeeklyUG
  )
  /\
  forall(s in GRADS) (
    hoursWeek[s] >= minWeeklyGrad
  );

% Each student can work no more than maxShiftsPerWeek shifts per week (a shift = a day worked)
constraint
  forall(s in STUDENTS) (
    sum(d in DAYS)(worksDay[s,d]) <= maxShiftsPerWeek
  );

% Count distinct students used per day and cap it
constraint
  forall(d in DAYS) (
    studentsUsedDay[d] = sum(s in STUDENTS)(worksDay[s,d])
  )
  /\
  forall(d in DAYS) (
    studentsUsedDay[d] <= maxStudentsPerDay
  );

% Total gross pay (define for later minimization)
constraint
  totalPay =
    sum(s in STUDENTS, d in DAYS, h in HOURS)(
      wage[s] * int2float(x[s,d,h])
    );


% Objective

solve minimize totalPay;