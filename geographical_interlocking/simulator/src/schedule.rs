// Auto-generated Rust code to instantiate state machines for the schedule

use std::collections::HashMap;

use crate::{entity_types::*, configuration_types::Entities, enums::*, eval_context::EvalContext, graph::Graph, graphs::*, timestamp::timestamp};

pub struct Schedule {
    pub LinkLTR: Vec<LinkLTRStateMachine>,
    pub LinkRTL: Vec<LinkRTLStateMachine>,
    pub PointControl: Vec<PointControlStateMachine>,
    pub PointLockLeft: Vec<PointLockLeftStateMachine>,
    pub PointLockRight: Vec<PointLockRightStateMachine>,
    pub PointOperation: Vec<PointOperationStateMachine>,
    pub Point: Vec<PointStateMachine>,
    pub RouteAutomaticRelease: Vec<RouteAutomaticReleaseStateMachine>,
    pub RouteCheck: Vec<RouteCheckStateMachine>,
    pub RouteControl: Vec<RouteControlStateMachine>,
    pub RouteFindingResponse: Vec<RouteFindingResponseStateMachine>,
    pub RouteFindingSearch: Vec<RouteFindingSearchStateMachine>,
    pub RouteManualReleaseDispatch: Vec<RouteManualReleaseDispatchStateMachine>,
    pub RouteManualRelease: Vec<RouteManualReleaseStateMachine>,
    pub RouteMonitoring: Vec<RouteMonitoringStateMachine>,
    pub Route: Vec<RouteStateMachine>,
    pub SignalControl: Vec<SignalControlStateMachine>,
    pub Signal: Vec<SignalStateMachine>,
    pub Transit: Vec<TransitStateMachine>,
    pub Zone: Vec<ZoneStateMachine>,
    pub Point_SCIP: Vec<Point_SCIPStruct>,
    pub Point_SCICC: Vec<Point_SCICCStruct>,
    pub Route_SCICC: Vec<Route_SCICCStruct>,
    pub Signal_SCICC: Vec<Signal_SCICCStruct>,
    pub Signal_SCIRBC: Vec<Signal_SCIRBCStruct>,
    pub Transit_SCICC: Vec<Transit_SCICCStruct>,
    pub Zone_SCITDS: Vec<Zone_SCITDSStruct>,
    pub Zone_SCICC: Vec<Zone_SCICCStruct>,
}

pub struct ScheduleBuilder {
    LinkLTR: Vec<LinkLTRStateMachine>,
    LinkRTL: Vec<LinkRTLStateMachine>,
    PointControl: Vec<PointControlStateMachine>,
    PointLockLeft: Vec<PointLockLeftStateMachine>,
    PointLockRight: Vec<PointLockRightStateMachine>,
    PointOperation: Vec<PointOperationStateMachine>,
    Point: Vec<PointStateMachine>,
    RouteAutomaticRelease: Vec<RouteAutomaticReleaseStateMachine>,
    RouteCheck: Vec<RouteCheckStateMachine>,
    RouteControl: Vec<RouteControlStateMachine>,
    RouteFindingResponse: Vec<RouteFindingResponseStateMachine>,
    RouteFindingSearch: Vec<RouteFindingSearchStateMachine>,
    RouteManualReleaseDispatch: Vec<RouteManualReleaseDispatchStateMachine>,
    RouteManualRelease: Vec<RouteManualReleaseStateMachine>,
    RouteMonitoring: Vec<RouteMonitoringStateMachine>,
    Route: Vec<RouteStateMachine>,
    SignalControl: Vec<SignalControlStateMachine>,
    Signal: Vec<SignalStateMachine>,
    Transit: Vec<TransitStateMachine>,
    Zone: Vec<ZoneStateMachine>,
    Point_SCIP: Vec<Point_SCIPStruct>,
    Point_SCICC: Vec<Point_SCICCStruct>,
    Route_SCICC: Vec<Route_SCICCStruct>,
    Signal_SCICC: Vec<Signal_SCICCStruct>,
    Signal_SCIRBC: Vec<Signal_SCIRBCStruct>,
    Transit_SCICC: Vec<Transit_SCICCStruct>,
    Zone_SCITDS: Vec<Zone_SCITDSStruct>,
    Zone_SCICC: Vec<Zone_SCICCStruct>,
}

impl ScheduleBuilder {
    pub fn new(entities: Entities) -> Self {
        let mut LinkLTR = Vec::new();
        entities.link.iter().for_each(|x| {
            LinkLTR.push(LinkLTRStateMachine::new(x.clone()));
        });
        let mut LinkRTL = Vec::new();
        entities.link.iter().for_each(|x| {
            LinkRTL.push(LinkRTLStateMachine::new(x.clone()));
        });
        let mut PointControl = Vec::new();
        entities.point.iter().for_each(|x| {
            PointControl.push(PointControlStateMachine::new(x.clone()));
        });
        let mut PointLockLeft = Vec::new();
        entities.point.iter().for_each(|x| {
            PointLockLeft.push(PointLockLeftStateMachine::new(x.clone()));
        });
        let mut PointLockRight = Vec::new();
        entities.point.iter().for_each(|x| {
            PointLockRight.push(PointLockRightStateMachine::new(x.clone()));
        });
        let mut PointOperation = Vec::new();
        entities.point.iter().for_each(|x| {
            PointOperation.push(PointOperationStateMachine::new(x.clone()));
        });
        let mut Point = Vec::new();
        entities.point.iter().for_each(|x| {
            Point.push(PointStateMachine::new(x.clone()));
        });
        let mut RouteAutomaticRelease = Vec::new();
        entities.transit.iter().for_each(|x| {
            RouteAutomaticRelease.push(RouteAutomaticReleaseStateMachine::new(x.clone()));
        });
        let mut RouteCheck = Vec::new();
        entities.route.iter().for_each(|x| {
            RouteCheck.push(RouteCheckStateMachine::new(x.clone()));
        });
        let mut RouteControl = Vec::new();
        entities.transit.iter().for_each(|x| {
            RouteControl.push(RouteControlStateMachine::new(x.clone()));
        });
        let mut RouteFindingResponse = Vec::new();
        entities.ise.iter().for_each(|x| {
            RouteFindingResponse.push(RouteFindingResponseStateMachine::new(x.clone()));
        });
        let mut RouteFindingSearch = Vec::new();
        entities.ise.iter().for_each(|x| {
            RouteFindingSearch.push(RouteFindingSearchStateMachine::new(x.clone()));
        });
        let mut RouteManualReleaseDispatch = Vec::new();
        entities.ise.iter().for_each(|x| {
            RouteManualReleaseDispatch.push(RouteManualReleaseDispatchStateMachine::new(x.clone()));
        });
        let mut RouteManualRelease = Vec::new();
        entities.transit.iter().for_each(|x| {
            RouteManualRelease.push(RouteManualReleaseStateMachine::new(x.clone()));
        });
        let mut RouteMonitoring = Vec::new();
        entities.transit.iter().for_each(|x| {
            RouteMonitoring.push(RouteMonitoringStateMachine::new(x.clone()));
        });
        let mut Route = Vec::new();
        entities.transit.iter().for_each(|x| {
            Route.push(RouteStateMachine::new(x.clone()));
        });
        let mut SignalControl = Vec::new();
        entities.signal.iter().for_each(|x| {
            SignalControl.push(SignalControlStateMachine::new(x.clone()));
        });
        let mut Signal = Vec::new();
        entities.signal.iter().for_each(|x| {
            Signal.push(SignalStateMachine::new(x.clone()));
        });
        let mut Transit = Vec::new();
        entities.transit.iter().for_each(|x| {
            Transit.push(TransitStateMachine::new(x.clone()));
        });
        let mut Zone = Vec::new();
        entities.zone.iter().for_each(|x| {
            Zone.push(ZoneStateMachine::new(x.clone()));
        });
        let mut Point_SCIP = Vec::new();
        entities.point.iter().for_each(|c| {
            Point_SCIP.push(Point_SCIPStruct::new(c.clone()));
        });
        let mut Point_SCICC = Vec::new();
        entities.point.iter().for_each(|c| {
            Point_SCICC.push(Point_SCICCStruct::new(c.clone()));
        });
        let mut Route_SCICC = Vec::new();
        entities.route.iter().for_each(|c| {
            Route_SCICC.push(Route_SCICCStruct::new(c.clone()));
        });
        let mut Signal_SCICC = Vec::new();
        entities.signal.iter().for_each(|c| {
            Signal_SCICC.push(Signal_SCICCStruct::new(c.clone()));
        });
        let mut Signal_SCIRBC = Vec::new();
        entities.signal.iter().for_each(|c| {
            Signal_SCIRBC.push(Signal_SCIRBCStruct::new(c.clone()));
        });
        let mut Transit_SCICC = Vec::new();
        entities.transit.iter().for_each(|c| {
            Transit_SCICC.push(Transit_SCICCStruct::new(c.clone()));
        });
        let mut Zone_SCITDS = Vec::new();
        entities.zone.iter().for_each(|c| {
            Zone_SCITDS.push(Zone_SCITDSStruct::new(c.clone()));
        });
        let mut Zone_SCICC = Vec::new();
        entities.zone.iter().for_each(|c| {
            Zone_SCICC.push(Zone_SCICCStruct::new(c.clone()));
        });
        Self {
            LinkLTR,
            LinkRTL,
            PointControl,
            PointLockLeft,
            PointLockRight,
            PointOperation,
            Point,
            RouteAutomaticRelease,
            RouteCheck,
            RouteControl,
            RouteFindingResponse,
            RouteFindingSearch,
            RouteManualReleaseDispatch,
            RouteManualRelease,
            RouteMonitoring,
            Route,
            SignalControl,
            Signal,
            Transit,
            Zone,
            Point_SCIP,
            Point_SCICC,
            Route_SCICC,
            Signal_SCICC,
            Signal_SCIRBC,
            Transit_SCICC,
            Zone_SCITDS,
            Zone_SCICC,
        }
    }

    pub fn build(self) -> Schedule {
        Schedule {
            LinkLTR: self.LinkLTR,
            LinkRTL: self.LinkRTL,
            PointControl: self.PointControl,
            PointLockLeft: self.PointLockLeft,
            PointLockRight: self.PointLockRight,
            PointOperation: self.PointOperation,
            Point: self.Point,
            RouteAutomaticRelease: self.RouteAutomaticRelease,
            RouteCheck: self.RouteCheck,
            RouteControl: self.RouteControl,
            RouteFindingResponse: self.RouteFindingResponse,
            RouteFindingSearch: self.RouteFindingSearch,
            RouteManualReleaseDispatch: self.RouteManualReleaseDispatch,
            RouteManualRelease: self.RouteManualRelease,
            RouteMonitoring: self.RouteMonitoring,
            Route: self.Route,
            SignalControl: self.SignalControl,
            Signal: self.Signal,
            Transit: self.Transit,
            Zone: self.Zone,
            Point_SCIP: self.Point_SCIP,
            Point_SCICC: self.Point_SCICC,
            Route_SCICC: self.Route_SCICC,
            Signal_SCICC: self.Signal_SCICC,
            Signal_SCIRBC: self.Signal_SCIRBC,
            Transit_SCICC: self.Transit_SCICC,
            Zone_SCITDS: self.Zone_SCITDS,
            Zone_SCICC: self.Zone_SCICC,
        }
    }
}

impl Schedule {
    fn build_eval_context(&self) -> EvalContext {
        let Point_SCIP_map: HashMap<String, Point_SCIPStruct> =
            self.Point_SCIP.clone().into_iter().map(|iface| (iface.entity.name.clone(), iface)).collect();
        let Point_SCICC_map: HashMap<String, Point_SCICCStruct> =
            self.Point_SCICC.clone().into_iter().map(|iface| (iface.entity.name.clone(), iface)).collect();
        let Route_SCICC_map: HashMap<String, Route_SCICCStruct> =
            self.Route_SCICC.clone().into_iter().map(|iface| (iface.entity.name.clone(), iface)).collect();
        let Signal_SCICC_map: HashMap<String, Signal_SCICCStruct> =
            self.Signal_SCICC.clone().into_iter().map(|iface| (iface.entity.name.clone(), iface)).collect();
        let Signal_SCIRBC_map: HashMap<String, Signal_SCIRBCStruct> =
            self.Signal_SCIRBC.clone().into_iter().map(|iface| (iface.entity.name.clone(), iface)).collect();
        let Transit_SCICC_map: HashMap<String, Transit_SCICCStruct> =
            self.Transit_SCICC.clone().into_iter().map(|iface| (iface.entity.name.clone(), iface)).collect();
        let Zone_SCITDS_map: HashMap<String, Zone_SCITDSStruct> =
            self.Zone_SCITDS.clone().into_iter().map(|iface| (iface.entity.name.clone(), iface)).collect();
        let Zone_SCICC_map: HashMap<String, Zone_SCICCStruct> =
            self.Zone_SCICC.clone().into_iter().map(|iface| (iface.entity.name.clone(), iface)).collect();
        let LinkLTR_map: HashMap<String, LinkLTRStateMachine> =
            self.LinkLTR.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();
        let LinkRTL_map: HashMap<String, LinkRTLStateMachine> =
            self.LinkRTL.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();
        let PointControl_map: HashMap<String, PointControlStateMachine> =
            self.PointControl.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();
        let PointLockLeft_map: HashMap<String, PointLockLeftStateMachine> =
            self.PointLockLeft.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();
        let PointLockRight_map: HashMap<String, PointLockRightStateMachine> =
            self.PointLockRight.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();
        let PointOperation_map: HashMap<String, PointOperationStateMachine> =
            self.PointOperation.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();
        let Point_map: HashMap<String, PointStateMachine> =
            self.Point.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();
        let RouteAutomaticRelease_map: HashMap<String, RouteAutomaticReleaseStateMachine> =
            self.RouteAutomaticRelease.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();
        let RouteCheck_map: HashMap<String, RouteCheckStateMachine> =
            self.RouteCheck.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();
        let RouteControl_map: HashMap<String, RouteControlStateMachine> =
            self.RouteControl.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();
        let RouteFindingResponse_map: HashMap<String, RouteFindingResponseStateMachine> =
            self.RouteFindingResponse.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();
        let RouteFindingSearch_map: HashMap<String, RouteFindingSearchStateMachine> =
            self.RouteFindingSearch.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();
        let RouteManualReleaseDispatch_map: HashMap<String, RouteManualReleaseDispatchStateMachine> =
            self.RouteManualReleaseDispatch.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();
        let RouteManualRelease_map: HashMap<String, RouteManualReleaseStateMachine> =
            self.RouteManualRelease.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();
        let RouteMonitoring_map: HashMap<String, RouteMonitoringStateMachine> =
            self.RouteMonitoring.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();
        let Route_map: HashMap<String, RouteStateMachine> =
            self.Route.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();
        let SignalControl_map: HashMap<String, SignalControlStateMachine> =
            self.SignalControl.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();
        let Signal_map: HashMap<String, SignalStateMachine> =
            self.Signal.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();
        let Transit_map: HashMap<String, TransitStateMachine> =
            self.Transit.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();
        let Zone_map: HashMap<String, ZoneStateMachine> =
            self.Zone.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();
        EvalContext {
            LinkLTR: LinkLTR_map,
            LinkRTL: LinkRTL_map,
            PointControl: PointControl_map,
            PointLockLeft: PointLockLeft_map,
            PointLockRight: PointLockRight_map,
            PointOperation: PointOperation_map,
            Point: Point_map,
            RouteAutomaticRelease: RouteAutomaticRelease_map,
            RouteCheck: RouteCheck_map,
            RouteControl: RouteControl_map,
            RouteFindingResponse: RouteFindingResponse_map,
            RouteFindingSearch: RouteFindingSearch_map,
            RouteManualReleaseDispatch: RouteManualReleaseDispatch_map,
            RouteManualRelease: RouteManualRelease_map,
            RouteMonitoring: RouteMonitoring_map,
            Route: Route_map,
            SignalControl: SignalControl_map,
            Signal: Signal_map,
            Transit: Transit_map,
            Zone: Zone_map,
            Point_SCIP: Point_SCIP_map,
            Point_SCICC: Point_SCICC_map,
            Route_SCICC: Route_SCICC_map,
            Signal_SCICC: Signal_SCICC_map,
            Signal_SCIRBC: Signal_SCIRBC_map,
            Transit_SCICC: Transit_SCICC_map,
            Zone_SCITDS: Zone_SCITDS_map,
            Zone_SCICC: Zone_SCICC_map,
        }
    }

    pub fn transition(&mut self, now: timestamp) {
        let len = self.Zone.len();
        for i in 0..len {
            let ctx = self.build_eval_context();
            self.Zone[i].evaluate_terms(&ctx, now);
            self.Zone[i].transition(now);
        }
        for i in 0..self.Transit.len() {
            let ctx = self.build_eval_context();
            self.Transit[i].evaluate_terms(&ctx, now);
            self.Transit[i].transition(now);
        }
        let len = self.Point.len();
        for i in 0..len {
            let ctx = self.build_eval_context();
            self.Point[i].evaluate_terms(&ctx, now);
            self.Point[i].transition(now);
            let ctx = self.build_eval_context();
            self.PointLockLeft[i].evaluate_terms(&ctx, now);
            self.PointLockLeft[i].transition(now);
            let ctx = self.build_eval_context();
            self.PointLockRight[i].evaluate_terms(&ctx, now);
            self.PointLockRight[i].transition(now);
            let ctx = self.build_eval_context();
            self.PointControl[i].evaluate_terms(&ctx, now);
            self.PointControl[i].transition(now);
            let ctx = self.build_eval_context();
            self.PointOperation[i].evaluate_terms(&ctx, now);
            self.PointOperation[i].transition(now);
        }
        for i in 0..self.RouteCheck.len() {
            let ctx = self.build_eval_context();
            self.RouteCheck[i].evaluate_terms(&ctx, now);
            self.RouteCheck[i].transition(now);
        }
        for i in 0..self.RouteFindingSearch.len() {
            let ctx = self.build_eval_context();
            self.RouteFindingSearch[i].evaluate_terms(&ctx, now);
            self.RouteFindingSearch[i].transition(now);
        }
        for i in 0..self.RouteFindingResponse.len() {
            let ctx = self.build_eval_context();
            self.RouteFindingResponse[i].evaluate_terms(&ctx, now);
            self.RouteFindingResponse[i].transition(now);
        }
        for i in 0..self.RouteManualReleaseDispatch.len() {
            let ctx = self.build_eval_context();
            self.RouteManualReleaseDispatch[i].evaluate_terms(&ctx, now);
            self.RouteManualReleaseDispatch[i].transition(now);
        }
        for i in 0..self.LinkLTR.len() {
            let ctx = self.build_eval_context();
            self.LinkLTR[i].evaluate_terms(&ctx, now);
            self.LinkLTR[i].transition(now);
        }
        for i in 0..self.LinkRTL.len() {
            let ctx = self.build_eval_context();
            self.LinkRTL[i].evaluate_terms(&ctx, now);
            self.LinkRTL[i].transition(now);
        }
        for i in 0..self.RouteMonitoring.len() {
            let ctx = self.build_eval_context();
            self.RouteMonitoring[i].evaluate_terms(&ctx, now);
            self.RouteMonitoring[i].transition(now);
        }
        for i in 0..self.RouteFindingSearch.len() {
            let ctx = self.build_eval_context();
            self.RouteFindingSearch[i].evaluate_terms(&ctx, now);
            self.RouteFindingSearch[i].transition(now);
        }
        for i in 0..self.RouteFindingResponse.len() {
            let ctx = self.build_eval_context();
            self.RouteFindingResponse[i].evaluate_terms(&ctx, now);
            self.RouteFindingResponse[i].transition(now);
        }
        for i in 0..self.RouteManualReleaseDispatch.len() {
            let ctx = self.build_eval_context();
            self.RouteManualReleaseDispatch[i].evaluate_terms(&ctx, now);
            self.RouteManualReleaseDispatch[i].transition(now);
        }
        for i in 0..self.LinkLTR.len() {
            let ctx = self.build_eval_context();
            self.LinkLTR[i].evaluate_terms(&ctx, now);
            self.LinkLTR[i].transition(now);
        }
        for i in 0..self.LinkRTL.len() {
            let ctx = self.build_eval_context();
            self.LinkRTL[i].evaluate_terms(&ctx, now);
            self.LinkRTL[i].transition(now);
        }
        for i in 0..self.RouteMonitoring.len() {
            let ctx = self.build_eval_context();
            self.RouteMonitoring[i].evaluate_terms(&ctx, now);
            self.RouteMonitoring[i].transition(now);
        }
        for i in 0..self.RouteFindingSearch.len() {
            let ctx = self.build_eval_context();
            self.RouteFindingSearch[i].evaluate_terms(&ctx, now);
            self.RouteFindingSearch[i].transition(now);
        }
        for i in 0..self.RouteFindingResponse.len() {
            let ctx = self.build_eval_context();
            self.RouteFindingResponse[i].evaluate_terms(&ctx, now);
            self.RouteFindingResponse[i].transition(now);
        }
        for i in 0..self.RouteManualReleaseDispatch.len() {
            let ctx = self.build_eval_context();
            self.RouteManualReleaseDispatch[i].evaluate_terms(&ctx, now);
            self.RouteManualReleaseDispatch[i].transition(now);
        }
        for i in 0..self.LinkLTR.len() {
            let ctx = self.build_eval_context();
            self.LinkLTR[i].evaluate_terms(&ctx, now);
            self.LinkLTR[i].transition(now);
        }
        for i in 0..self.LinkRTL.len() {
            let ctx = self.build_eval_context();
            self.LinkRTL[i].evaluate_terms(&ctx, now);
            self.LinkRTL[i].transition(now);
        }
        for i in 0..self.RouteMonitoring.len() {
            let ctx = self.build_eval_context();
            self.RouteMonitoring[i].evaluate_terms(&ctx, now);
            self.RouteMonitoring[i].transition(now);
        }
        for i in 0..self.RouteFindingSearch.len() {
            let ctx = self.build_eval_context();
            self.RouteFindingSearch[i].evaluate_terms(&ctx, now);
            self.RouteFindingSearch[i].transition(now);
        }
        for i in 0..self.RouteFindingResponse.len() {
            let ctx = self.build_eval_context();
            self.RouteFindingResponse[i].evaluate_terms(&ctx, now);
            self.RouteFindingResponse[i].transition(now);
        }
        for i in 0..self.RouteManualReleaseDispatch.len() {
            let ctx = self.build_eval_context();
            self.RouteManualReleaseDispatch[i].evaluate_terms(&ctx, now);
            self.RouteManualReleaseDispatch[i].transition(now);
        }
        for i in 0..self.LinkLTR.len() {
            let ctx = self.build_eval_context();
            self.LinkLTR[i].evaluate_terms(&ctx, now);
            self.LinkLTR[i].transition(now);
        }
        for i in 0..self.LinkRTL.len() {
            let ctx = self.build_eval_context();
            self.LinkRTL[i].evaluate_terms(&ctx, now);
            self.LinkRTL[i].transition(now);
        }
        for i in 0..self.RouteMonitoring.len() {
            let ctx = self.build_eval_context();
            self.RouteMonitoring[i].evaluate_terms(&ctx, now);
            self.RouteMonitoring[i].transition(now);
        }
        for i in 0..self.RouteFindingSearch.len() {
            let ctx = self.build_eval_context();
            self.RouteFindingSearch[i].evaluate_terms(&ctx, now);
            self.RouteFindingSearch[i].transition(now);
        }
        for i in 0..self.RouteFindingResponse.len() {
            let ctx = self.build_eval_context();
            self.RouteFindingResponse[i].evaluate_terms(&ctx, now);
            self.RouteFindingResponse[i].transition(now);
        }
        for i in 0..self.RouteManualReleaseDispatch.len() {
            let ctx = self.build_eval_context();
            self.RouteManualReleaseDispatch[i].evaluate_terms(&ctx, now);
            self.RouteManualReleaseDispatch[i].transition(now);
        }
        for i in 0..self.LinkLTR.len() {
            let ctx = self.build_eval_context();
            self.LinkLTR[i].evaluate_terms(&ctx, now);
            self.LinkLTR[i].transition(now);
        }
        for i in 0..self.LinkRTL.len() {
            let ctx = self.build_eval_context();
            self.LinkRTL[i].evaluate_terms(&ctx, now);
            self.LinkRTL[i].transition(now);
        }
        for i in 0..self.RouteMonitoring.len() {
            let ctx = self.build_eval_context();
            self.RouteMonitoring[i].evaluate_terms(&ctx, now);
            self.RouteMonitoring[i].transition(now);
        }
        for i in 0..self.RouteFindingSearch.len() {
            let ctx = self.build_eval_context();
            self.RouteFindingSearch[i].evaluate_terms(&ctx, now);
            self.RouteFindingSearch[i].transition(now);
        }
        for i in 0..self.RouteFindingResponse.len() {
            let ctx = self.build_eval_context();
            self.RouteFindingResponse[i].evaluate_terms(&ctx, now);
            self.RouteFindingResponse[i].transition(now);
        }
        for i in 0..self.RouteManualReleaseDispatch.len() {
            let ctx = self.build_eval_context();
            self.RouteManualReleaseDispatch[i].evaluate_terms(&ctx, now);
            self.RouteManualReleaseDispatch[i].transition(now);
        }
        for i in 0..self.LinkLTR.len() {
            let ctx = self.build_eval_context();
            self.LinkLTR[i].evaluate_terms(&ctx, now);
            self.LinkLTR[i].transition(now);
        }
        for i in 0..self.LinkRTL.len() {
            let ctx = self.build_eval_context();
            self.LinkRTL[i].evaluate_terms(&ctx, now);
            self.LinkRTL[i].transition(now);
        }
        for i in 0..self.RouteMonitoring.len() {
            let ctx = self.build_eval_context();
            self.RouteMonitoring[i].evaluate_terms(&ctx, now);
            self.RouteMonitoring[i].transition(now);
        }
        for i in 0..self.RouteFindingSearch.len() {
            let ctx = self.build_eval_context();
            self.RouteFindingSearch[i].evaluate_terms(&ctx, now);
            self.RouteFindingSearch[i].transition(now);
        }
        for i in 0..self.RouteFindingResponse.len() {
            let ctx = self.build_eval_context();
            self.RouteFindingResponse[i].evaluate_terms(&ctx, now);
            self.RouteFindingResponse[i].transition(now);
        }
        for i in 0..self.RouteManualReleaseDispatch.len() {
            let ctx = self.build_eval_context();
            self.RouteManualReleaseDispatch[i].evaluate_terms(&ctx, now);
            self.RouteManualReleaseDispatch[i].transition(now);
        }
        for i in 0..self.LinkLTR.len() {
            let ctx = self.build_eval_context();
            self.LinkLTR[i].evaluate_terms(&ctx, now);
            self.LinkLTR[i].transition(now);
        }
        for i in 0..self.LinkRTL.len() {
            let ctx = self.build_eval_context();
            self.LinkRTL[i].evaluate_terms(&ctx, now);
            self.LinkRTL[i].transition(now);
        }
        for i in 0..self.RouteMonitoring.len() {
            let ctx = self.build_eval_context();
            self.RouteMonitoring[i].evaluate_terms(&ctx, now);
            self.RouteMonitoring[i].transition(now);
        }
        for i in 0..self.RouteFindingSearch.len() {
            let ctx = self.build_eval_context();
            self.RouteFindingSearch[i].evaluate_terms(&ctx, now);
            self.RouteFindingSearch[i].transition(now);
        }
        for i in 0..self.RouteFindingResponse.len() {
            let ctx = self.build_eval_context();
            self.RouteFindingResponse[i].evaluate_terms(&ctx, now);
            self.RouteFindingResponse[i].transition(now);
        }
        for i in 0..self.RouteManualReleaseDispatch.len() {
            let ctx = self.build_eval_context();
            self.RouteManualReleaseDispatch[i].evaluate_terms(&ctx, now);
            self.RouteManualReleaseDispatch[i].transition(now);
        }
        for i in 0..self.LinkLTR.len() {
            let ctx = self.build_eval_context();
            self.LinkLTR[i].evaluate_terms(&ctx, now);
            self.LinkLTR[i].transition(now);
        }
        for i in 0..self.LinkRTL.len() {
            let ctx = self.build_eval_context();
            self.LinkRTL[i].evaluate_terms(&ctx, now);
            self.LinkRTL[i].transition(now);
        }
        for i in 0..self.RouteMonitoring.len() {
            let ctx = self.build_eval_context();
            self.RouteMonitoring[i].evaluate_terms(&ctx, now);
            self.RouteMonitoring[i].transition(now);
        }
        for i in 0..self.RouteFindingSearch.len() {
            let ctx = self.build_eval_context();
            self.RouteFindingSearch[i].evaluate_terms(&ctx, now);
            self.RouteFindingSearch[i].transition(now);
        }
        for i in 0..self.RouteFindingResponse.len() {
            let ctx = self.build_eval_context();
            self.RouteFindingResponse[i].evaluate_terms(&ctx, now);
            self.RouteFindingResponse[i].transition(now);
        }
        for i in 0..self.RouteManualReleaseDispatch.len() {
            let ctx = self.build_eval_context();
            self.RouteManualReleaseDispatch[i].evaluate_terms(&ctx, now);
            self.RouteManualReleaseDispatch[i].transition(now);
        }
        for i in 0..self.LinkLTR.len() {
            let ctx = self.build_eval_context();
            self.LinkLTR[i].evaluate_terms(&ctx, now);
            self.LinkLTR[i].transition(now);
        }
        for i in 0..self.LinkRTL.len() {
            let ctx = self.build_eval_context();
            self.LinkRTL[i].evaluate_terms(&ctx, now);
            self.LinkRTL[i].transition(now);
        }
        for i in 0..self.RouteMonitoring.len() {
            let ctx = self.build_eval_context();
            self.RouteMonitoring[i].evaluate_terms(&ctx, now);
            self.RouteMonitoring[i].transition(now);
        }
        for i in 0..self.RouteFindingSearch.len() {
            let ctx = self.build_eval_context();
            self.RouteFindingSearch[i].evaluate_terms(&ctx, now);
            self.RouteFindingSearch[i].transition(now);
        }
        for i in 0..self.RouteFindingResponse.len() {
            let ctx = self.build_eval_context();
            self.RouteFindingResponse[i].evaluate_terms(&ctx, now);
            self.RouteFindingResponse[i].transition(now);
        }
        for i in 0..self.RouteManualReleaseDispatch.len() {
            let ctx = self.build_eval_context();
            self.RouteManualReleaseDispatch[i].evaluate_terms(&ctx, now);
            self.RouteManualReleaseDispatch[i].transition(now);
        }
        for i in 0..self.LinkLTR.len() {
            let ctx = self.build_eval_context();
            self.LinkLTR[i].evaluate_terms(&ctx, now);
            self.LinkLTR[i].transition(now);
        }
        for i in 0..self.LinkRTL.len() {
            let ctx = self.build_eval_context();
            self.LinkRTL[i].evaluate_terms(&ctx, now);
            self.LinkRTL[i].transition(now);
        }
        for i in 0..self.RouteMonitoring.len() {
            let ctx = self.build_eval_context();
            self.RouteMonitoring[i].evaluate_terms(&ctx, now);
            self.RouteMonitoring[i].transition(now);
        }
        for i in 0..self.RouteAutomaticRelease.len() {
            let ctx = self.build_eval_context();
            self.RouteAutomaticRelease[i].evaluate_terms(&ctx, now);
            self.RouteAutomaticRelease[i].transition(now);
        }
        for i in 0..self.RouteManualRelease.len() {
            let ctx = self.build_eval_context();
            self.RouteManualRelease[i].evaluate_terms(&ctx, now);
            self.RouteManualRelease[i].transition(now);
        }
        for i in 0..self.Route.len() {
            let ctx = self.build_eval_context();
            self.Route[i].evaluate_terms(&ctx, now);
            self.Route[i].transition(now);
        }
        for i in 0..self.RouteControl.len() {
            let ctx = self.build_eval_context();
            self.RouteControl[i].evaluate_terms(&ctx, now);
            self.RouteControl[i].transition(now);
        }
        for i in 0..self.Signal.len() {
            let ctx = self.build_eval_context();
            self.Signal[i].evaluate_terms(&ctx, now);
            self.Signal[i].transition(now);
        }
        for i in 0..self.SignalControl.len() {
            let ctx = self.build_eval_context();
            self.SignalControl[i].evaluate_terms(&ctx, now);
            self.SignalControl[i].transition(now);
        }
        let ctx = self.build_eval_context();
        for iface in &mut self.Point_SCIP { iface.complete_cycle(&ctx); }
        for iface in &mut self.Point_SCICC { iface.complete_cycle(&ctx); }
        for iface in &mut self.Route_SCICC { iface.complete_cycle(&ctx); }
        for iface in &mut self.Signal_SCICC { iface.complete_cycle(&ctx); }
        for iface in &mut self.Signal_SCIRBC { iface.complete_cycle(&ctx); }
        for iface in &mut self.Transit_SCICC { iface.complete_cycle(&ctx); }
        for iface in &mut self.Zone_SCITDS { iface.complete_cycle(&ctx); }
        for iface in &mut self.Zone_SCICC { iface.complete_cycle(&ctx); }
        println!("Schedule transition completed.");
    }
}