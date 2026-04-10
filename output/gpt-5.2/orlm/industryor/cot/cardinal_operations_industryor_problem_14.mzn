% Parameters (with values embedded)
int: n = 10; % number of stages
array[1..n] of int: r = [3, 5, 2, 4, 6, 5, 4, 3, 2, 1]; % requirements
int: a = 10; % buy new tool cost
int: b = 1;  % slow repair cost
int: c = 3;  % fast repair cost
int: p = 3;  % slow repair duration
int: q = 1;  % fast repair duration

int: total_r = sum(j in 1..n)(r[j]);

% Variables
array[1..n] of var 0..total_r: buy;        % new tools purchased at start of stage j
array[1..n] of var 0..total_r: slow_send;  % tools sent to slow repair at end of stage j
array[1..n] of var 0..total_r: fast_send;  % tools sent to fast repair at end of stage j
array[1..n] of var 0..total_r: avail;      % tools available at start of stage j

% Constraints
constraint avail[1] = buy[1];

constraint
  forall(j in 2..n) (
    avail[j] =
      buy[j]
      + (if j - p >= 1 then slow_send[j - p] else 0 endif)
      + (if j - q >= 1 then fast_send[j - q] else 0 endif)
  );

% Must meet demand each stage
constraint forall(j in 1..n) (avail[j] >= r[j]);

% All tools used in a stage must be sent for repair afterwards
constraint forall(j in 1..n) (slow_send[j] + fast_send[j] = r[j]);

% Objective
var int: total_cost =
  a * sum(j in 1..n)(buy[j]) +
  b * sum(j in 1..n)(slow_send[j]) +
  c * sum(j in 1..n)(fast_send[j]);

solve minimize total_cost;