int: n = 10;
array[1..n] of int: r = [3, 5, 2, 4, 6, 5, 4, 3, 2, 1];

int: a = 10; % buy new
int: b = 1;  % slow repair
int: c = 3;  % fast repair
int: p = 3;  % slow repair lead time
int: q = 1;  % fast repair lead time

int: T = n + p; % horizon to account for returns after stage n

% Decision variables:
% x[j] = tools bought new at start of stage j
% s[j] = tools sent to slow repair at end of stage j
% f[j] = tools sent to fast repair at end of stage j
array[1..n] of var 0..sum(r): x;
array[1..n] of var 0..sum(r): s;
array[1..n] of var 0..sum(r): f;

% inv[t] = tools available at start of stage t (t=1..n) and track further until n+p
array[1..T+1] of var 0..sum(r): inv;

% Helper: number of tools returning at start of stage t (from earlier repairs)
array[1..T+1] of var 0..sum(r): ret;

constraint inv[1] = 0;

% Compute returns
constraint
  forall(t in 1..T+1) (
    ret[t] =
      sum(j in 1..n where j + p + 1 == t)(s[j]) +
      sum(j in 1..n where j + q + 1 == t)(f[j])
  );

% Inventory flow and meeting demand
constraint
  forall(t in 1..T) (
    inv[t+1] = inv[t] + (if t <= n then x[t] else 0 endif) + ret[t] - (if t <= n then r[t] else 0 endif)
  );

constraint forall(t in 1..T+1)(inv[t] >= 0);

% All tools used in stage j must be sent for repair at end of stage j
constraint forall(j in 1..n)(s[j] + f[j] = r[j]);

% Objective: minimize total cost (purchase + repairs)
var int: total_cost = a * sum(j in 1..n)(x[j]) + b * sum(j in 1..n)(s[j]) + c * sum(j in 1..n)(f[j]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "x (buy new)       = ", show(x), "\n",
  "s (slow repair)   = ", show(s), "\n",
  "f (fast repair)   = ", show(f), "\n",
  "inv[1..n+1]       = ", show([inv[t] | t in 1..n+1]), "\n"
];