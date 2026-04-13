% Bus driver/crew staffing (24h, 6 periods of 4h each; each person works 8h = 2 consecutive periods)

int: N = 6;
set of int: SHIFTS = 1..N;

array[SHIFTS] of int: req = [60, 70, 60, 50, 20, 30];

% cover[i,j] = 1 if staff starting at period i covers demand period j
% i covers i and (i+1) with wrap-around from 6 to 1
array[SHIFTS, SHIFTS] of int: cover =
  array2d(SHIFTS, SHIFTS,
    [ 1,1,0,0,0,0,
      0,1,1,0,0,0,
      0,0,1,1,0,0,
      0,0,0,1,1,0,
      0,0,0,0,1,1,
      1,0,0,0,0,1 ]
  );

array[SHIFTS] of var 0..sum(req): x;   % staff starting at the beginning of period i
var 0..sum(req): total_staff;

constraint forall(j in SHIFTS) (
  sum(i in SHIFTS) (cover[i,j] * x[i]) >= req[j]
);

constraint total_staff = sum(i in SHIFTS)(x[i]);

solve minimize total_staff;

output [
  "total_staff=", show(total_staff), "\n",
  "starts per period=", show(x), "\n"
];