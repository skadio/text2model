% Parameters
int: courses;
int: periods;
int: rooms;

array[1..courses, 1..periods] of 0..1: available;
array[1..courses, 1..courses] of 0..1: conflict;
array[1..courses] of int: requirement;

% Variables
array[1..courses, 1..periods] of var 0..1: lect;   % lect[i,j] = 1 if course i is scheduled in period j

% Constraints
constraint
    forall(i in 1..courses, j in 1..periods) (
        lect[i,j] <= available[i,j]            % respect availability
    );

constraint
    forall(i in 1..courses) (
        sum(j in 1..periods)(lect[i,j]) = requirement[i]   % satisfy lecture requirements
    );

constraint
    forall(j in 1..periods) (
        sum(i in 1..courses)(lect[i,j]) <= rooms           % period capacity
    );

constraint
    forall(j in 1..periods,
           i in 1..courses,
           k in i+1..courses where conflict[i,k] = 1) (
        lect[i,j] + lect[k,j] <= 1                         % no conflicting courses in same period
    );

% Objective
solve satisfy;