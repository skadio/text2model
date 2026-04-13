% Parameters (with values embedded)
int: W = 8;
set of int: Weeks = 1..W;

int: initial_skilled = 50;
int: target_new_trained_by_end = 50;

int: hours_normal = 40;
int: hours_overtime = 60;

float: prodI_per_hour = 10.0;  % kg/h per worker (skilled or trained)
float: prodII_per_hour = 6.0;  % kg/h per worker (skilled or trained)

array[Weeks] of int: demandI = [10000, 10000, 12000, 12000, 16000, 16000, 20000, 20000];
array[Weeks] of int: demandII = [ 6000,  7200,  8400, 10800, 10800, 12000, 12000, 12000];

int: wage_skilled_normal = 360;
int: wage_skilled_overtime = 540;
int: wage_trainee = 120;
int: wage_trained = 240;

% Training: in any 2-week training "batch", one skilled trainer can train up to 3 trainees.
% During training weeks, both the trainer and the trainees do not produce.
int: train_duration = 2;
int: trainees_per_trainer = 3;

float: penaltyI = 0.5; % yuan per kg-week of backlog
float: penaltyII = 0.6;

% Variables
% Start t trainees in week w (w=1..7). They are in training in weeks w and w+1,
% and become trained (productive at trained wage) starting week w+2.
array[1..W-1] of var 0..target_new_trained_by_end: startTrainees;

% In week w, choose how many available skilled workers work overtime (rest are normal hours).
array[Weeks] of var 0..initial_skilled: skilledOT;

% Allocation of production worker-hours (normal + overtime) between foods.
array[Weeks] of var float: hoursI;  % total worker-hours assigned to food I
array[Weeks] of var float: hoursII; % total worker-hours assigned to food II

% Weekly production (kg)
array[Weeks] of var float: prodI;
array[Weeks] of var float: prodII;

% Backlog (undelivered amount) carried after each week (kg)
array[Weeks] of var float: backlogI;
array[Weeks] of var float: backlogII;

% Helper counts per week (integers)
array[Weeks] of var 0..initial_skilled: trainers;         % skilled workers tied up training in week w
array[Weeks] of var 0..target_new_trained_by_end: trainees_in_training;
array[Weeks] of var 0..target_new_trained_by_end: trained_available; % trained workers available to produce in week w

% Total cost components
var float: wageCost;
var float: penaltyCost;
var float: totalCost;

% Constraints
% Bounds and nonnegativity
constraint forall(w in Weeks) (
  hoursI[w] >= 0.0 /\ hoursII[w] >= 0.0 /\
  prodI[w] >= 0.0 /\ prodII[w] >= 0.0 /\
  backlogI[w] >= 0.0 /\ backlogII[w] >= 0.0
);

% Training dynamics
% trainees in training in week w are those started in w or w-1 (if applicable)
constraint trainees_in_training[1] = startTrainees[1];
constraint forall(w in 2..W-1) (
  trainees_in_training[w] = startTrainees[w] + startTrainees[w-1]
);
constraint trainees_in_training[W] = startTrainees[W-1];

% Each week, trainers needed: each trainer can handle up to 3 trainees (capacity),
% so trainees_in_training[w] <= 3 * trainers[w]
constraint forall(w in Weeks) (
  trainees_in_training[w] <= trainees_per_trainer * trainers[w]
);

% Trainers cannot exceed skilled pool; overtime workers also from skilled pool.
constraint forall(w in Weeks) (
  trainers[w] + skilledOT[w] <= initial_skilled
);

% Trained workers available in week w are those who started training in week w-2
constraint trained_available[1] = 0;
constraint trained_available[2] = 0;
constraint forall(w in 3..W) (
  trained_available[w] = startTrainees[w-2]
);

% Must have trained total 50 new workers by end of week 8:
% those started in weeks 1..6 complete by week 8 (since start in 7 completes in 9).
constraint sum(w in 1..W-2)(startTrainees[w]) = target_new_trained_by_end;

% Production capacity (worker-hours available)
% Skilled producing workers in week w: initial_skilled - trainers[w]
% Of those, skilledOT[w] work 60h, remaining work 40h.
% Trained producing workers in week w: trained_available[w], all at 40h (no overtime specified for them).
constraint forall(w in Weeks) (
  hoursI[w] + hoursII[w]
  <=
  (initial_skilled - trainers[w] - skilledOT[w]) * hours_normal
  + skilledOT[w] * hours_overtime
  + trained_available[w] * hours_normal
);

% Production from assigned hours
constraint forall(w in Weeks) (
  prodI[w] = prodI_per_hour * hoursI[w] /\
  prodII[w] = prodII_per_hour * hoursII[w]
);

% Backlog flow: backlog[w] = max(0, backlog[w-1] + demand[w] - production[w])
constraint backlogI[1] >= demandI[1] - prodI[1];
constraint backlogI[1] >= 0.0;
constraint forall(w in 2..W) (
  backlogI[w] >= backlogI[w-1] + int2float(demandI[w]) - prodI[w] /\
  backlogI[w] >= 0.0
);

constraint backlogII[1] >= demandII[1] - prodII[1];
constraint backlogII[1] >= 0.0;
constraint forall(w in 2..W) (
  backlogII[w] >= backlogII[w-1] + int2float(demandII[w]) - prodII[w] /\
  backlogII[w] >= 0.0
);

% Cost calculations
constraint wageCost =
  sum(w in Weeks)(
      % Skilled workers paid as normal or overtime regardless of training status:
      (initial_skilled - skilledOT[w]) * wage_skilled_normal
    + skilledOT[w] * wage_skilled_overtime
      % Trainees paid during training weeks:
    + trainees_in_training[w] * wage_trainee
      % Trained (new) workers paid after training completion, when available:
    + trained_available[w] * wage_trained
  );

constraint penaltyCost =
  sum(w in Weeks)(
    penaltyI * backlogI[w] + penaltyII * backlogII[w]
  );

constraint totalCost = wageCost + penaltyCost;

% Objective
solve minimize totalCost;