% Parameters
int: n = 10;
array[1..n] of int: r = [3, 5, 2, 4, 6, 5, 4, 3, 2, 1];

int: a = 10; % buy new
int: b = 1;  % slow repair
int: c = 3;  % fast repair
int: p = 3;  % slow repair lead time
int: q = 1;  % fast repair lead time

int: Rsum = sum(j in 1..n)(r[j]);

% Variables
array[1..n] of var 0..Rsum: buy;        % new tools purchased at stage j
array[1..n] of var 0..Rsum: slow_send;  % tools sent to slow repair at end of stage j
array[1..n] of var 0..Rsum: fast_send;  % tools sent to fast repair at end of stage j

array[1..n] of var 0..Rsum: avail;      % tools available at start of stage j

var 0..(a*Rsum + max(b,c)*Rsum): total_cost;

% Constraints
constraint avail[1] = buy[1];

constraint forall(j in 2..n) (
  avail[j] =
    buy[j]
    + (if j - p >= 1 then slow_send[j - p] else 0 endif)
    + (if j - q >= 1 then fast_send[j - q] else 0 endif)
);

constraint forall(j in 1..n) (
  avail[j] >= r[j]
);

constraint forall(j in 1..n) (
  slow_send[j] + fast_send[j] = r[j]
);

constraint total_cost =
  a * sum(j in 1..n)(buy[j]) +
  b * sum(j in 1..n)(slow_send[j]) +
  c * sum(j in 1..n)(fast_send[j]);

% Objective
solve minimize total_cost;