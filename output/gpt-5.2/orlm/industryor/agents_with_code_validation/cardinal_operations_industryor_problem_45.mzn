% Parameters
int: nStudents = 6;                       % total number of students
set of int: STUDENTS = 1..nStudents;

int: nDays = 5;                           % Monday..Friday
set of int: DAYS = 1..nDays;

int: nUndergrads = 4;                     % students 1..4 are undergraduates
set of int: UNDERGRADS = 1..nUndergrads;

set of int: GRADS = 5..6;                 % students 5..6 are graduate students

int: openHoursPerDay = 14;                % lab open 8:00 to 22:00 => 14 hours/day

array[STUDENTS] of float: wage =          % CNY per hour
  [10.0, 10.0, 9.9, 9.8, 10.8, 11.3];

% max available duty hours for each student on each day (Mon..Fri)
array[STUDENTS, DAYS] of int: maxHours =
  [| 6, 0, 6, 0, 7   % student 1
   | 0, 8, 9, 6, 0   % student 2
   | 4, 8, 3, 0, 5   % student 3
   | 5, 5, 6, 0, 4   % student 4
   | 3, 0, 5, 8, 0   % student 5
   | 0, 6, 0, 6, 5   % student 6
  |];

int: minWeeklyUndergradHours = 8;         % each undergrad must work at least 8 hours/week
int: minWeeklyGradHours = 7;              % each grad must work at least 7 hours/week
int: maxShiftsPerStudent = 2;             % each student can work no more than 2 shifts/week
int: maxStudentsPerDay = 3;               % no more than 3 students scheduled per day


% Variables
array[STUDENTS, DAYS] of var 0..openHoursPerDay: hours; % hours student s works on day d
array[STUDENTS, DAYS] of var bool: works;               % true if student s works (has a shift) on day d


% Constraints

% Link "hours" and "works", and enforce daily availability limits
constraint
  forall(s in STUDENTS, d in DAYS) (
    hours[s,d] <= maxHours[s,d] /\
    hours[s,d] <= openHoursPerDay * bool2int(works[s,d]) /\
    hours[s,d] >= bool2int(works[s,d])          % if works then at least 1 hour (a non-empty shift)
  );

% Coverage: exactly one student on duty for all open hours each day
constraint
  forall(d in DAYS) (
    sum(s in STUDENTS)(hours[s,d]) = openHoursPerDay
  );

% Weekly minimum hours requirements by student type
constraint
  forall(s in UNDERGRADS) (
    sum(d in DAYS)(hours[s,d]) >= minWeeklyUndergradHours
  );

constraint
  forall(s in GRADS) (
    sum(d in DAYS)(hours[s,d]) >= minWeeklyGradHours
  );

% Max number of shifts per student per week
constraint
  forall(s in STUDENTS) (
    sum(d in DAYS)(bool2int(works[s,d])) <= maxShiftsPerStudent
  );

% Limit number of distinct students scheduled per day
constraint
  forall(d in DAYS) (
    sum(s in STUDENTS)(bool2int(works[s,d])) <= maxStudentsPerDay
  );


% Objective
solve minimize
  sum(s in STUDENTS, d in DAYS) (wage[s] * int2float(hours[s,d]));