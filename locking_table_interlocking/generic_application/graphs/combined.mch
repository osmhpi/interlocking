
MACHINE MAIN_MACHINE_FOR_Interlocking
SETS /* enumerated */
  RouteState={RELEASED,PREPARING,SET};
  GraphState={GINITIAL,GLEFT,GRIGHT,GUNDETERMINED};
  PointState={LEFT,RIGHT,UNDETERMINED};
  EndPosition={EULYNX_LEFT,EULYNX_RIGHT,EULYNX_NO_END_POSITION,EULYNX_UNINTENDED};
  RouteGraphState={GROUTEINITIAL,GRELEASED,GPREPARING,GSET}
ABSTRACT_VARIABLES
  W1__GState,
  W1__State,
  W2__GState,
  W2__State,
  R1__GState,
  R1__State,
  R2__GState,
  R2__State
INVARIANT
    W1__GState : GraphState
  & W1__State : PointState
  & W2__GState : GraphState
  & W2__State : PointState
  & R1__GState : RouteGraphState
  & R1__State : RouteState
  & R2__GState : RouteGraphState
  & R2__State : RouteState
INITIALISATION
    BEGIN
           W1__GState := GINITIAL
        ||
           W1__State := UNDETERMINED
      ;
           W2__GState := GINITIAL
        ||
           W2__State := UNDETERMINED
      ;
           R1__GState := GROUTEINITIAL
        ||
           R1__State := RELEASED
      ;
           R2__GState := GROUTEINITIAL
        ||
           R2__State := RELEASED
      ;
          Interlocking__R1__InitialTransition
        ;
          Interlocking__R2__InitialTransition
        ;
          Interlocking__W1__InitialTransition(EULYNX_LEFT)
        ;
          Interlocking__W2__InitialTransition(EULYNX_LEFT)
    END
OPERATIONS
  Interlocking__W1__InitialTransition(DetectedEndPosition) = 
    PRE 
        DetectedEndPosition : EndPosition
    THEN
      SELECT 
          W1__GState = GINITIAL
      THEN 
        IF DetectedEndPosition = EULYNX_LEFT THEN
             W1__GState := GLEFT
          ||
             W1__State := LEFT
        ELSIF DetectedEndPosition = EULYNX_RIGHT THEN
             W1__GState := GRIGHT
          ||
             W1__State := RIGHT
        ELSE
             W1__GState := GUNDETERMINED
          ||
             W1__State := UNDETERMINED
        END
      END
    END;
  
  Interlocking__W1__Transition(RouteStateRequestingPointRight,RouteStateRequestingPointLeft) = 
    PRE 
        RouteStateRequestingPointRight : POW(RouteState)
      & RouteStateRequestingPointLeft : POW(RouteState)
    THEN
      SELECT 
          W1__GState = GLEFT
      THEN 
          IF PREPARING : RouteStateRequestingPointRight THEN
               W1__GState := GRIGHT
            ||
               W1__State := RIGHT
          END
        ;
          SELECT 
              W1__GState = GRIGHT
          THEN 
            IF PREPARING : RouteStateRequestingPointLeft THEN
                 W1__GState := GLEFT
              ||
                 W1__State := LEFT
            END
          END
      END
    END;
  
  Interlocking__W2__InitialTransition(DetectedEndPosition) = 
    PRE 
        DetectedEndPosition : EndPosition
    THEN
      SELECT 
          W2__GState = GINITIAL
      THEN 
        IF DetectedEndPosition = EULYNX_LEFT THEN
             W2__GState := GLEFT
          ||
             W2__State := LEFT
        ELSIF DetectedEndPosition = EULYNX_RIGHT THEN
             W2__GState := GRIGHT
          ||
             W2__State := RIGHT
        ELSE
             W2__GState := GUNDETERMINED
          ||
             W2__State := UNDETERMINED
        END
      END
    END;
  
  Interlocking__W2__Transition(RouteStateRequestingPointRight,RouteStateRequestingPointLeft) = 
    PRE 
        RouteStateRequestingPointRight : POW(RouteState)
      & RouteStateRequestingPointLeft : POW(RouteState)
    THEN
      SELECT 
          W2__GState = GLEFT
      THEN 
          IF PREPARING : RouteStateRequestingPointRight THEN
               W2__GState := GRIGHT
            ||
               W2__State := RIGHT
          END
        ;
          SELECT 
              W2__GState = GRIGHT
          THEN 
            IF PREPARING : RouteStateRequestingPointLeft THEN
                 W2__GState := GLEFT
              ||
                 W2__State := LEFT
            END
          END
      END
    END;
  
  Interlocking__R1__InitialTransition = 
    SELECT 
        R1__GState = GROUTEINITIAL
    THEN 
         R1__GState := GRELEASED
      ||
         R1__State := RELEASED
    END;
  
  Interlocking__R1__Request = 
    SELECT 
        R1__GState = GRELEASED
    THEN 
         R1__GState := GPREPARING
      ||
         R1__State := PREPARING
    END;
  
  Interlocking__R2__InitialTransition = 
    SELECT 
        R2__GState = GROUTEINITIAL
    THEN 
         R2__GState := GRELEASED
      ||
         R2__State := RELEASED
    END;
  
  Interlocking__R2__Request = 
    SELECT 
        R2__GState = GRELEASED
    THEN 
         R2__GState := GPREPARING
      ||
         R2__State := PREPARING
    END;
  
  BigStep(RequestRouteR1,RequestRouteR2) = 
    PRE 
        RequestRouteR1 : BOOL
      & RequestRouteR2 : BOOL
    THEN
        IF RequestRouteR1 = TRUE THEN
          Interlocking__R1__Request
        END
      ;
        IF RequestRouteR2 = TRUE THEN
          Interlocking__R2__Request
        END
      ;
        Interlocking__W1__Transition({R1__State},{R2__State})
      ;
        Interlocking__W2__Transition({R1__State},{R2__State})
    END
END
