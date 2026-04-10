include "globals.mzn";

/*
  Workforce planning with training (2-week), overtime option, two products with backlog.
  Data is embedded as requested.
*/

%-----------------------%
% Data
%-----------------------%
int: W = 8;                         % weeks
set of int: Weeks = 1..W;

int: init_skilled = 50;             % initial skilled workers
int: target_new_trained = 50;       % number of new workers to be trained by end of week 8

int: hours_normal = 40;
int: hours_overtime = 60;

% Production rates (kg per hour per skilled-equivalent worker)
int: rateI = 10;
int: rateII = 6;

% Weekly demands (kg)
array[Weeks] of int: demI  = [10000,10000,12000,12000,16000,16000,20000,20000];
array[Weeks] of int: demII = [ 6000, 7200, 8400,10800,10800,12000,12000,12000];

% Wages (yuan per worker-week)
int: wage_skilled_normal = 360;
int: wage_skilled_ot     = 540;
int: wage_trainee        = 120;     % during 2-week training (non-productive)
int: wage_trained        = 240;     % after training, productive like skilled

% Backlog penalty (yuan per kg per week of delay)
% Implemented as cost per kg of end-of-week backlog.
float: penI  = 0.5;
float: penII = 0.6;

% Training capacity: in a 2-week training cohort, 1 skilled can train up to 3 trainees.
int: trainees_per_trainer = 3;

%-----------------------%
% Decision variables
%-----------------------%

% Start x[t] trainees in week t (t=1..7). Training lasts weeks t and t+1.
array[1..W-1] of var 0..target_new_trained: startTrain;

% Number of skilled workers assigned to be trainers in week w (non-productive that week)
array[Weeks] of var 0..init_skilled: trainers;

% Productive skilled workers in week w split by normal vs overtime hours
array[Weeks] of var 0..init_skilled: skilled_normal;
array[Weeks] of var 0..init_skilled: skilled_overtime;

% Number of trained (post-training) workers available in week w, split normal vs overtime
array[Weeks] of var 0..target_new_trained: trained_available;
array[Weeks] of var 0..target_new_trained: trained_normal;
array[Weeks] of var 0..target_new_trained: trained_overtime;

% Production quantities (kg) each week
array[Weeks] of var 0..1000000: prodI;
array[Weeks] of var 0..1000000: prodII;

% Allocation of total production capacity (in "skill-hours") to product I (rest to II)
array[Weeks] of var 0..100000000: capHours;      % total productive skill-hours
array[Weeks] of var 0..100000000: capHoursI;     % skill-hours devoted to product I

% End-of-week backlog (kg) for each product
array[Weeks] of var 0..100000000: backI;
array[Weeks] of var 0..100000000: backII;

%-----------------------%
% Constraints
%-----------------------%

% Trainers are determined by trainees in training in each week.
% Trainees in training week w are those started in w and w-1.
constraint trainers[1] * trainees_per_trainer >= startTrain[1];
constraint forall(w in 2..W-1)(
  trainers[w] * trainees_per_trainer >= startTrain[w-1] + startTrain[w]
);
constraint trainers[W] * trainees_per_trainer >= startTrain[W-1];

% Total trained by end of week 8 = 50 (i.e., all trainees started by week 7 complete by week 8)
constraint sum(t in 1..W-1)(startTrain[t]) = target_new_trained;

% Trained workers become available starting week t+2 for cohort started at t.
constraint forall(w in Weeks)(
  trained_available[w] =
    sum(t in 1..W-1 where t+2 <= w)( startTrain[t] )
);

% Workforce balance for skilled workers:
% initial skilled are either trainers, productive normal, or productive overtime each week.
constraint forall(w in Weeks)(
  trainers[w] + skilled_normal[w] + skilled_overtime[w] = init_skilled
);

% Trained workforce split each week into normal vs overtime (all productive once trained)
constraint forall(w in Weeks)(
  trained_normal[w] + trained_overtime[w] = trained_available[w]
);

% Total productive capacity in skill-hours
constraint forall(w in Weeks)(
  capHours[w] =
      hours_normal  * (skilled_normal[w] + trained_normal[w])
    + hours_overtime * (skilled_overtime[w] + trained_overtime[w])
);

% Convert capacity to production using integer allocation of skill-hours.
% With rates: I uses 1 hour -> 10 kg, II uses 1 hour -> 6 kg.
constraint forall(w in Weeks)(
  capHoursI[w] <= capHours[w]
);
constraint forall(w in Weeks)(
  prodI[w] = rateI * capHoursI[w]
);
constraint forall(w in Weeks)(
  prodII[w] = rateII * (capHours[w] - capHoursI[w])
);

% Backlog dynamics: backlog carries over; production reduces it; unmet demand becomes backlog.
constraint backI[1] = max(0, demI[1] - prodI[1]);
constraint backII[1] = max(0, demII[1] - prodII[1]);

constraint forall(w in 2..W)(
  backI[w] = max(0, backI[w-1] + demI[w] - prodI[w])
);
constraint forall(w in 2..W)(
  backII[w] = max(0, backII[w-1] + demII[w] - prodII[w])
);

%-----------------------%
% Objective: minimize total wages + backlog penalties
%-----------------------%

% Weekly trainee count in training (non-productive), for wage calculation
array[Weeks] of var 0..target_new_trained: trainees_in_training;
constraint trainees_in_training[1] = startTrain[1];
constraint forall(w in 2..W-1)(
  trainees_in_training[w] = startTrain[w-1] + startTrain[w]
);
constraint trainees_in_training[W] = startTrain[W-1];

var int: wageCost =
    sum(w in Weeks)(
        wage_skilled_normal * skilled_normal[w]
      + wage_skilled_ot     * skilled_overtime[w]
      + wage_trained        * (trained_normal[w] + trained_overtime[w])
      + wage_trainee        * trainees_in_training[w]
    );

var float: penaltyCost =
    sum(w in Weeks)( penI  * int2float(backI[w]) + penII * int2float(backII[w]) );

var float: totalCost = int2float(wageCost) + penaltyCost;

solve minimize totalCost;

%-----------------------%
% Output
%-----------------------%
output [
  "Total cost = ", show(totalCost), "\n",
  "Wage cost  = ", show(wageCost), "\n",
  "Penalty    = ", show(penaltyCost), "\n\n",
  "Start trainees (week 1..7): ", show([startTrain[t] | t in 1..W-1]), "\n\n",
  "Week | trainers | skilledN skilledOT | trainedAvail trainedN trainedOT | prodI prodII | backI backII\n",
  concat([ show(w), " | ",
           show(trainers[w]), " | ",
           show(skilled_normal[w]), " ", show(skilled_overtime[w]), " | ",
           show(trained_available[w]), " ", show(trained_normal[w]), " ", show(trained_overtime[w]), " | ",
           show(prodI[w]), " ", show(prodII[w]), " | ",
           show(backI[w]), " ", show(backII[w]), "\n"
         | w in Weeks ])
];