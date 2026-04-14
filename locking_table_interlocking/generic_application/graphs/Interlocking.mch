MACHINE Interlocking
INCLUDES W1.Point, W2.Point, R1.Route, R2.Route
DEFINITIONS
  VISB_SVG_FILE == "trackplan.svg";
  VISB_SVG_UPDATES1== rec(`id`:"W1R",visibility: bool(W1.State = RIGHT));
  VISB_SVG_UPDATES2== rec(`id`:"W2R",visibility: bool(W2.State = RIGHT));
INITIALISATION
  R1.InitialTransition;
  R2.InitialTransition;
  W1.InitialTransition(EULYNX_LEFT);
  W2.InitialTransition(EULYNX_LEFT)
OPERATIONS
  BigStep(RequestRouteR1, RequestRouteR2) =
    BEGIN
      IF RequestRouteR1 = TRUE THEN
        R1.Request
      END;
      IF RequestRouteR2 = TRUE THEN
        R2.Request
      END;
      W1.Transition({R1.State}, {R2.State});
      W2.Transition({R1.State}, {R2.State})
    END
END//MACHINE
