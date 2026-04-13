% Parameters (with values embedded)
int: H = 24;                 % hours in a day
int: shiftLen = 8;           % each waiter works 8 continuous hours
set of int: Hours = 0..H-1;  % represent hours as 0..23

% Demand per hour derived from the table:
% 2-6:4, 6-10:8, 10-14:10, 14-18:7, 18-22:12, 22-2:4 (wrap-around)
array[Hours] of int: demand = [
  4, 4, 4, 4,   % hours 0,1,2,3 (belongs to 22~2 and 2~6 segments as specified)
  4, 4,         % hours 4,5 (2~6)
  8, 8, 8, 8,   % hours 6,7,8,9 (6~10)
  10,10,10,10,  % hours 10,11,12,13 (10~14)
  7, 7, 7, 7,   % hours 14,15,16,17 (14~18)
  12,12,12,12,  % hours 18,19,20,21 (18~22)
  4, 4          % hours 22,23 (22~2)
];

% Variables
% x[s] = number of waiters starting at hour s (work hours s..s+7 modulo 24)
array[Hours] of var 0..100: x;

% Constraints
% Coverage: for each hour h, sum of starts in the previous 8 hours must meet demand[h]
constraint
  forall(h in Hours) (
    sum(k in 0..shiftLen-1) ( x[(h - k + H) mod H] ) >= demand[h]
  );

% Objective
solve minimize sum(s in Hours)(x[s]);