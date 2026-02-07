// Auto-generated evaluation context for state machines
use std::collections::HashMap;

use crate::graphs::*;
use crate::entity_types::*;

pub type LinkLTR_map = HashMap<String, LinkLTRStateMachine>;
pub type LinkRTL_map = HashMap<String, LinkRTLStateMachine>;
pub type PointControl_map = HashMap<String, PointControlStateMachine>;
pub type PointLockLeft_map = HashMap<String, PointLockLeftStateMachine>;
pub type PointLockRight_map = HashMap<String, PointLockRightStateMachine>;
pub type PointOperation_map = HashMap<String, PointOperationStateMachine>;
pub type Point_map = HashMap<String, PointStateMachine>;
pub type RouteAutomaticRelease_map = HashMap<String, RouteAutomaticReleaseStateMachine>;
pub type RouteCheck_map = HashMap<String, RouteCheckStateMachine>;
pub type RouteControl_map = HashMap<String, RouteControlStateMachine>;
pub type RouteFindingResponse_map = HashMap<String, RouteFindingResponseStateMachine>;
pub type RouteFindingSearch_map = HashMap<String, RouteFindingSearchStateMachine>;
pub type RouteManualReleaseDispatch_map = HashMap<String, RouteManualReleaseDispatchStateMachine>;
pub type RouteManualRelease_map = HashMap<String, RouteManualReleaseStateMachine>;
pub type RouteMonitoring_map = HashMap<String, RouteMonitoringStateMachine>;
pub type Route_map = HashMap<String, RouteStateMachine>;
pub type SignalControl_map = HashMap<String, SignalControlStateMachine>;
pub type Signal_map = HashMap<String, SignalStateMachine>;
pub type Transit_map = HashMap<String, TransitStateMachine>;
pub type Zone_map = HashMap<String, ZoneStateMachine>;
pub type Point_SCIP_map = HashMap<String, Point_SCIPStruct>;
pub type Point_SCICC_map = HashMap<String, Point_SCICCStruct>;
pub type Route_SCICC_map = HashMap<String, Route_SCICCStruct>;
pub type Signal_SCICC_map = HashMap<String, Signal_SCICCStruct>;
pub type Signal_SCIRBC_map = HashMap<String, Signal_SCIRBCStruct>;
pub type Transit_SCICC_map = HashMap<String, Transit_SCICCStruct>;
pub type Zone_SCITDS_map = HashMap<String, Zone_SCITDSStruct>;
pub type Zone_SCICC_map = HashMap<String, Zone_SCICCStruct>;

pub struct EvalContext {
    pub LinkLTR: LinkLTR_map,
    pub LinkRTL: LinkRTL_map,
    pub PointControl: PointControl_map,
    pub PointLockLeft: PointLockLeft_map,
    pub PointLockRight: PointLockRight_map,
    pub PointOperation: PointOperation_map,
    pub Point: Point_map,
    pub RouteAutomaticRelease: RouteAutomaticRelease_map,
    pub RouteCheck: RouteCheck_map,
    pub RouteControl: RouteControl_map,
    pub RouteFindingResponse: RouteFindingResponse_map,
    pub RouteFindingSearch: RouteFindingSearch_map,
    pub RouteManualReleaseDispatch: RouteManualReleaseDispatch_map,
    pub RouteManualRelease: RouteManualRelease_map,
    pub RouteMonitoring: RouteMonitoring_map,
    pub Route: Route_map,
    pub SignalControl: SignalControl_map,
    pub Signal: Signal_map,
    pub Transit: Transit_map,
    pub Zone: Zone_map,
    pub Point_SCIP: Point_SCIP_map,
    pub Point_SCICC: Point_SCICC_map,
    pub Route_SCICC: Route_SCICC_map,
    pub Signal_SCICC: Signal_SCICC_map,
    pub Signal_SCIRBC: Signal_SCIRBC_map,
    pub Transit_SCICC: Transit_SCICC_map,
    pub Zone_SCITDS: Zone_SCITDS_map,
    pub Zone_SCICC: Zone_SCICC_map,
}