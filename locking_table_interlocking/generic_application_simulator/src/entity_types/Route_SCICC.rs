// Auto-generated Rust interface for entity type-related interface ports

use crate::{configuration_types::*, enums::*, eval_context::EvalContext, triggerable::Triggerable};

#[derive(Clone)]
pub struct Route_SCICCStruct {
    pub entity: EntitiesRouteItem,
    pub MsgRequestRoute: Triggerable<bool>, // input
    pub MsgReleaseRoute: Triggerable<bool>, // input
}

impl Route_SCICCStruct {
    pub fn new(entity: EntitiesRouteItem) -> Self {
        Self {
            entity,
            MsgRequestRoute: Triggerable::NotTriggered(false),
            MsgReleaseRoute: Triggerable::NotTriggered(false),
        }
    }
    pub fn complete_cycle(&mut self, ctx: &EvalContext) {
        self.MsgRequestRoute = Triggerable::NotTriggered(false);
        self.MsgReleaseRoute = Triggerable::NotTriggered(false);
    }
}
