% Parameters
int: nActivities = 7;                         % number of activities
set of int: ACT = 1..nActivities;             % activity index set

array[ACT] of string: actName = ["A","B","C","D","E","F","G"];  % activity names

array[ACT] of int: duration =                 % durations (days)
  [ 4, 3, 5, 2, 10, 10, 1 ];                  % A,B,C,D,E,F,G

int: workCostPerDay = 1000;                   % Euros per day (all activities)
int: machineCostPerDay = 5000;                % Euros per day (special machine)

% Precedence arcs (pred -> succ), encoded as pairs of indices into ACT
int: nPrec = 7;
array[1..nPrec] of int: pred = [1, 1, 5, 7, 4, 6, 6];  % A,A,E,G,D,F,F
array[1..nPrec] of int: succ = [7, 4, 6, 6, 3, 3, 2];  % G,D,F,F,C,C,B

int: idxA = 1;                                % index of activity A
int: idxB = 2;                                % index of activity B


% Variables
array[ACT] of var 0..sum(duration): start;    % start time (day) for each activity
array[ACT] of var 0..sum(duration): finish;   % finish time (day) for each activity

var 0..sum(duration): projectMakespan;        % maximum finish time over all activities

var 0..sum(duration): machineRentalTime;      % time from start(A) to finish(B)
var 0..intmax: totalWorkCost;                 % total labour cost
var 0..intmax: totalMachineCost;              % total machine rental cost
var 0..intmax: totalCost;                     % total cost objective


% Constraints

%-------------------------------
% Link start/finish with duration
%-------------------------------
constraint
  forall(a in ACT) (
    finish[a] = start[a] + duration[a]
  );

%-------------------------------
% Precedence constraints (pred -> succ)
% Enforce: succ starts after pred finishes
%-------------------------------
constraint
  forall(k in 1..nPrec) (
    start[succ[k]] >= finish[pred[k]]
  );

%-------------------------------
% Project makespan definition (max of all finishes)
%-------------------------------
constraint
  forall(a in ACT) (
    projectMakespan >= finish[a]
  );

%-------------------------------
% Machine rental time: from start(A) to finish(B)
%-------------------------------
constraint
  machineRentalTime = finish[idxB] - start[idxA];

% Ensure nonnegative rental time (implied by domain, but made explicit for clarity)
constraint
  machineRentalTime >= 0;

%-------------------------------
% Cost calculations
%-------------------------------

% Total labour/work cost: sum of (duration * cost/day)
constraint
  totalWorkCost = workCostPerDay * sum(a in ACT)(duration[a]);

% Total machine cost: rental time * cost/day
constraint
  totalMachineCost = machineCostPerDay * machineRentalTime;

% Total cost
constraint
  totalCost = totalWorkCost + totalMachineCost;


% Objective
solve minimize totalCost;