% Parameters
int: W = 8;                            % number of weeks
set of int: WEEKS = 1..W;

int: initial_skilled = 50;             % initially available skilled workers
int: target_new_trained = 50;          % total number of new workers to be trained by end of week 8

int: hours_normal = 40;                % normal weekly working hours
int: hours_overtime = 60;              % overtime weekly working hours

int: prod_I_per_hour = 10;             % kg/h per worker for food I
int: prod_II_per_hour = 6;             % kg/h per worker for food II

int: training_duration = 2;            % weeks per training batch (fixed to 2 in constraints below)
int: trainees_per_trainer = 3;         % max trainees per skilled trainer over a 2-week training period

int: wage_skilled_normal = 360;        % yuan per week for 40h skilled worker
int: wage_skilled_overtime = 540;      % yuan per week for 60h worker-week
int: wage_trainee_in_training = 120;   % yuan per week while in training
int: wage_new_after_training = 240;    % yuan per week after training (same productivity as skilled)

float: penalty_I = 0.5;                % yuan per kg per week of delay for food I
float: penalty_II = 0.6;               % yuan per kg per week of delay for food II

array[WEEKS] of int: demand_I =
  [10000, 10000, 12000, 12000, 16000, 16000, 20000, 20000];
array[WEEKS] of int: demand_II =
  [ 6000,  7200,  8400, 10800, 10800, 12000, 12000, 12000];

% Useful derived bounds for production variables
int: max_workers_total = initial_skilled + target_new_trained;
int: max_hours_week = hours_overtime;  % upper bound for any worker-week assignment
int: max_prod_I_week = max_workers_total * max_hours_week * prod_I_per_hour;
int: max_prod_II_week = max_workers_total * max_hours_week * prod_II_per_hour;


% Variables
% Workforce allocation (by week)
array[WEEKS] of var 0..max_workers_total: skilled_normal;    % skilled workers producing at 40h
array[WEEKS] of var 0..max_workers_total: skilled_overtime;  % skilled workers producing at 60h

array[WEEKS] of var 0..max_workers_total: trainers;          % skilled workers assigned to training (not producing)
array[WEEKS] of var 0..max_workers_total: trainees;          % new workers currently in training (not producing)

array[WEEKS] of var 0..max_workers_total: new_normal;        % trained new workers producing at 40h
array[WEEKS] of var 0..max_workers_total: new_overtime;      % trained new workers producing at 60h

% Production decisions (by week)
array[WEEKS] of var 0..max_prod_I_week: prod_I;              % kg of food I produced in week w
array[WEEKS] of var 0..max_prod_II_week: prod_II;            % kg of food II produced in week w

% Backlog / delayed delivery (end-of-week unmet demand)
array[WEEKS] of var 0..sum(demand_I): backlog_I;             % kg of food I delayed after week w
array[WEEKS] of var 0..sum(demand_II): backlog_II;           % kg of food II delayed after week w

% Training flow helpers
array[WEEKS] of var 0..max_workers_total: start_training;    % number of trainees starting in week w
array[WEEKS] of var 0..target_new_trained: cum_trained;      % number completed training and available by week w

% Cost components
var 0.0..1.0e12: total_wages;                                % total wage cost
var 0.0..1.0e12: total_penalty;                              % total delay penalty cost
var 0.0..2.0e12: total_cost;                                 % objective: minimize total_cost


% Constraints

%--------------------------
% Workforce availability and flow
%--------------------------

% Total workers allocated in any week cannot exceed total headcount (initial skilled + all potential new)
constraint
  forall(w in WEEKS)(
    skilled_normal[w] + skilled_overtime[w] + trainers[w] +
    trainees[w] + new_normal[w] + new_overtime[w]
    <= max_workers_total
  );

% No new workers exist before being trained; cap trainees/new by the target to be trained
constraint
  forall(w in WEEKS)(
    trainees[w] <= target_new_trained /\ new_normal[w] + new_overtime[w] <= target_new_trained
  );

% Skilled workers available each week are exactly the initial skilled pool
% (they are either producing normal, producing overtime, or training)
constraint
  forall(w in WEEKS)(
    skilled_normal[w] + skilled_overtime[w] + trainers[w] = initial_skilled
  );

% Training capacity: one trainer can train up to trainees_per_trainer over a 2-week batch.
constraint
  forall(w in WEEKS)(
    trainees[w] <= trainees_per_trainer * trainers[w]
  );

% Training lasts 2 weeks (training_duration is 2):
% trainees[w] equals those who started in week w plus those who started in week w-1.
constraint start_training[1] = trainees[1];
constraint trainees[2] = start_training[1] + start_training[2];
constraint
  forall(w in 3..W)(
    trainees[w] = start_training[w] + start_training[w-1]
  );

% Total trainees started across all weeks equals the target to be trained
constraint
  sum(w in WEEKS)(start_training[w]) = target_new_trained;

% New workers become available after completing 2 weeks of training:
% cum_trained[w] = sum of starts in weeks <= w-2
constraint cum_trained[1] = 0;
constraint cum_trained[2] = 0;
constraint
  forall(w in 3..W)(
    cum_trained[w] = sum(t in 1..w-2)(start_training[t])
  );

% New workers used for production in week w cannot exceed those trained by then
constraint
  forall(w in WEEKS)(
    new_normal[w] + new_overtime[w] <= cum_trained[w]
  );

%--------------------------
% Production capacity
%--------------------------

% Weekly production is limited by total labor-hours assigned to production.
% (We do not force producing to be maximal; prod_* are decision variables up to capacity.)
constraint
  forall(w in WEEKS)(
    prod_I[w] <=
      prod_I_per_hour * (
        hours_normal   * (skilled_normal[w] + new_normal[w]) +
        hours_overtime * (skilled_overtime[w] + new_overtime[w])
      )
  );

constraint
  forall(w in WEEKS)(
    prod_II[w] <=
      prod_II_per_hour * (
        hours_normal   * (skilled_normal[w] + new_normal[w]) +
        hours_overtime * (skilled_overtime[w] + new_overtime[w])
      )
  );

%--------------------------
% Demand satisfaction with backlog (delayed delivery)
%--------------------------

% Backlog flow for food I (end-of-week):
constraint backlog_I[1] = demand_I[1] - prod_I[1];
constraint
  forall(w in 2..W)(
    backlog_I[w] = backlog_I[w-1] + demand_I[w] - prod_I[w]
  );

% Backlog flow for food II (end-of-week):
constraint backlog_II[1] = demand_II[1] - prod_II[1];
constraint
  forall(w in 2..W)(
    backlog_II[w] = backlog_II[w-1] + demand_II[w] - prod_II[w]
  );

%--------------------------
% Cost accounting (wages and penalties)
%--------------------------

% Total wages: skilled normal, skilled overtime, trainers (skilled normal wage),
% trainees in training, and new workers (normal and overtime).
constraint
  total_wages =
    sum(w in WEEKS)(
      wage_skilled_normal       * skilled_normal[w] +
      wage_skilled_overtime     * skilled_overtime[w] +
      wage_skilled_normal       * trainers[w] +
      wage_trainee_in_training  * trainees[w] +
      wage_new_after_training   * new_normal[w] +
      wage_skilled_overtime     * new_overtime[w]
    );

% Total delay penalty: per kg per week for backlog at end of each week
constraint
  total_penalty =
    sum(w in WEEKS)(
      penalty_I  * int2float(backlog_I[w]) +
      penalty_II * int2float(backlog_II[w])
    );

% Total cost
constraint total_cost = total_wages + total_penalty;


% Objective
solve minimize total_cost;