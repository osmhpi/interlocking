MACHINE Route
SEES Enums
SETS
  RouteGraphState = {GROUTEINITIAL, GRELEASED, GPREPARING, GSET}
VARIABLES
  GState,
  State
INVARIANT
  GState : RouteGraphState &
  State : RouteState
INITIALISATION
  GState := GROUTEINITIAL ||
  State := RELEASED
OPERATIONS
  InitialTransition =
    SELECT GState = GROUTEINITIAL THEN
      GState := GRELEASED ||
      State := RELEASED
    END;
  Request =
    SELECT GState = GRELEASED THEN
      GState := GPREPARING ||
      State := PREPARING
    END
END//MACHINE
