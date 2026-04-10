% Bus driver/crew staffing for 24-hour service (6 periods of 4 hours each)
% Each worker starts at the beginning of a period and works 8 hours (covers 2 consecutive periods)
% Minimize total number of workers.

int: N = 6;
set of int: SHIFTS = 1..N;

array[SHIFTS] of int: req = [60, 70, 60, 50, 20, 30];

% cover[s,t] = 1 if a worker starting in period s covers demand in period t
array[SHIFTS, SHIFTS] of int: cover = array2d(SHIFTS, SHIFTS, [
  % t=1 2 3 4 5 6   (columns)
     1, 1, 0, 0, 0, 0,   % s=1 covers periods 1-2
     0, 1, 1, 0, 0, 0,   % s=2 covers periods 2-3
     0, 0, 1, 1, 0, 0,   % s=3 covers periods 3-4
     0, 0, 0, 1, 1, 0,   % s=4 covers periods 4-5
     0, 0, 0, 0, 1, 1,   % s=5 covers periods 5-6
     1, 0, 0, 0, 0, 1    % s=6 covers periods 6 and (wrap) 1
]);

array[SHIFTS] of var 0..sum(req): x; % x[s] = number of workers starting at period s
var 0..sum(req): total;

constraint forall(t in SHIFTS) (
  sum(s in SHIFTS)(cover[s,t] * x[s]) >= req[t]
);

constraint total = sum(s in SHIFTS)(x[s]);

solve minimize total;

output [
  "total=", show(total), "\n",
  "x=", show(x), "\n"
];