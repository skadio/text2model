int: courses;
int: periods;
int: rooms;

array[1..courses, 1..periods] of int: available;
array[1..courses, 1..courses] of int: conflict;
array[1..courses] of int: requirement;

array[1..courses, 1..periods] of var 0..1: x;

constraint
  forall(i in 1..courses) (
    sum(p in 1..periods) x[i,p] = requirement[i]
  );

constraint
  forall(i in 1..courses, p in 1..periods) (
    x[i,p] <= available[i,p]
  );

constraint
  forall(i in 1..courses, j in i+1..courses, p in 1..periods) (
    conflict[i,j] = 1 -> x[i,p] + x[j,p] <= 1
  );

constraint
  forall(p in 1..periods) (
    sum(i in 1..courses) x[i,p] <= rooms
  );

solve satisfy;

output [
  "Schedule:\n",
  concat([ show(i) ++ ": " ++ show([p | p in 1..periods where x[i,p] = 1]) ++ "\n" | i in 1..courses ])
];