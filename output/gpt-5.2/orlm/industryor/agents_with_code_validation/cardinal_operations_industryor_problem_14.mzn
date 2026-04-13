% Parameters
int: n = 10;                                  % number of planning stages
array[1..n] of int: r = [3, 5, 2, 4, 6, 5, 4, 3, 2, 1]; % tool requirements per stage

int: a = 10;                                  % cost per new tool purchase
int: b = 1;                                   % cost per tool sent to slow repair
int: c = 3;                                   % cost per tool sent to fast repair
int: p = 3;                                   % slow repair duration (stages)
int: q = 1;                                   % fast repair duration (stages)

int: Rmax = max(r);                           % maximum single-stage requirement (for bounds)

% Variables
array[1..n] of var 0..Rmax: buy;              % number of new tools purchased at stage j
array[1..n] of var 0..Rmax: slow_send;        % number of tools sent to slow repair at end of stage j
array[1..n] of var 0..Rmax: fast_send;        % number of tools sent to fast repair at end of stage j

array[1..n] of var 0..Rmax: available;        % tools available at start of stage j

var 0..(n*Rmax*a + n*Rmax*c): total_cost;     % total cost over the planning horizon

% Constraints

%-------------------------------
% Inventory / availability flow
%-------------------------------
% Available tools at start of stage 1 come only from purchases at stage 1
constraint
  available[1] = buy[1];

% For stages j>=2: available tools come from current purchases plus returns from repairs
constraint
  forall(j in 2..n) (
    available[j] =
      buy[j]
      + (if j - p >= 1 then slow_send[j - p] else 0 endif)
      + (if j - q >= 1 then fast_send[j - q] else 0 endif)
  );

%-----------------------------------------
% Demand satisfaction each planning stage
%-----------------------------------------
constraint
  forall(j in 1..n) (
    available[j] >= r[j]
  );

%------------------------------------------------
% Repair send limits (cannot send more than used)
%------------------------------------------------
% All tools used in stage j (= r[j]) must be sent to repair (slow or fast)
constraint
  forall(j in 1..n) (
    slow_send[j] + fast_send[j] = r[j]
  );

%-------------------------
% Total cost calculation
%-------------------------
constraint
  total_cost =
    a * sum(j in 1..n)(buy[j])
  + b * sum(j in 1..n)(slow_send[j])
  + c * sum(j in 1..n)(fast_send[j]);

% Objective
solve minimize total_cost;