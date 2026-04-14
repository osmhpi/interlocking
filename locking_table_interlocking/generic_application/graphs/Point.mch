MACHINE Point
SEES Enums
SETS
  GraphState = {GINITIAL, GLEFT, GRIGHT, GUNDETERMINED};
  PointState = {LEFT, RIGHT, UNDETERMINED};
  EndPosition = {EULYNX_LEFT, EULYNX_RIGHT, EULYNX_NO_END_POSITION, EULYNX_UNINTENDED}
VARIABLES
  GState,
  State
INVARIANT
  GState : GraphState &
  State : PointState
INITIALISATION
  GState := GINITIAL ||
  State := UNDETERMINED
OPERATIONS
  InitialTransition(DetectedEndPosition) =
    SELECT GState = GINITIAL THEN
      IF DetectedEndPosition = EULYNX_LEFT THEN
        GState := GLEFT ||
        State := LEFT
      ELSIF DetectedEndPosition = EULYNX_RIGHT THEN
        GState := GRIGHT ||
        State := RIGHT
      ELSE
        GState := GUNDETERMINED ||
        State := UNDETERMINED
      END
    END;
  Transition(RouteStateRequestingPointRight, RouteStateRequestingPointLeft) =
    SELECT GState = GLEFT THEN
      IF PREPARING : RouteStateRequestingPointRight THEN
        GState := GRIGHT ||
        State := RIGHT
      END;
    SELECT GState = GRIGHT THEN
      IF PREPARING : RouteStateRequestingPointLeft THEN
        GState := GLEFT ||
        State := LEFT
      END
    END
  END
END//MACHINE
