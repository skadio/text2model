% Parameters
int: ParticipantsPerCircular;      % Participants accommodated by one circular table
int: ParticipantsPerRectangular;   % Participants accommodated by one rectangular table

int: BoardsPerCircular;            % Poster boards provided by one circular table
int: BoardsPerRectangular;         % Poster boards provided by one rectangular table

int: GuestsPerCircular;            % Guests catered by one circular table
int: GuestsPerRectangular;         % Guests catered by one rectangular table

int: SpacePerCircular;             % Space required for one circular table
int: SpacePerRectangular;          % Space required for one rectangular table

int: TotalSpace;                   % Total available space

int: MinParticipants;              % Minimum required total participants
int: MinBoards;                    % Minimum required total poster boards


% Variables
% Upper bound derived from space limit and the smallest per-table space usage.
var 0..TotalSpace div min(SpacePerCircular, SpacePerRectangular): CircularTables;     % Number of circular tables to set up
var 0..TotalSpace div min(SpacePerCircular, SpacePerRectangular): RectangularTables;  % Number of rectangular tables to set up


% Constraints
% Space capacity: total space used by all tables cannot exceed available space
constraint
  SpacePerCircular * CircularTables
+ SpacePerRectangular * RectangularTables
<= TotalSpace;

% Minimum participants requirement: ensure enough participant capacity is provided
constraint
  ParticipantsPerCircular * CircularTables
+ ParticipantsPerRectangular * RectangularTables
>= MinParticipants;

% Minimum poster boards requirement: ensure enough boards are provided
constraint
  BoardsPerCircular * CircularTables
+ BoardsPerRectangular * RectangularTables
>= MinBoards;


% Objective
solve maximize
  GuestsPerCircular * CircularTables
+ GuestsPerRectangular * RectangularTables;