// Auto-generated Rust interface for entity type-related interface ports

use crate::{configuration_types::*, enums::*, eval_context::EvalContext, triggerable::Triggerable};

#[derive(Clone)]
pub struct Point_SCIPStruct {
    pub entity: EntitiesPointItem,
    pub DetectedEndPosition: Triggerable<EulynxEndPosition>, // input
    pub CommandedEndPosition: EulynxCommandedEndPosition, // output
}

impl Point_SCIPStruct {
    pub fn new(entity: EntitiesPointItem) -> Self {
        Self {
            entity,
            DetectedEndPosition: Triggerable::NotTriggered(EulynxEndPosition::NO_END_POSITION),
            CommandedEndPosition: EulynxCommandedEndPosition::NOT_COMMANDED,
        }
    }
    pub fn complete_cycle(&mut self, ctx: &EvalContext) {
        self.CommandedEndPosition = EulynxCommandedEndPosition::NOT_COMMANDED;
        if (match (Some(ctx.PointOperation.get(&self.entity.name).unwrap().State), Some(EulynxCommandedEndPosition::LEFT)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false) {
            self.CommandedEndPosition = EulynxCommandedEndPosition::LEFT;
        }
        if (match (Some(ctx.PointOperation.get(&self.entity.name).unwrap().State), Some(EulynxCommandedEndPosition::RIGHT)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false) {
            self.CommandedEndPosition = EulynxCommandedEndPosition::RIGHT;
        }
        if (match (Some(ctx.PointOperation.get(&self.entity.name).unwrap().State), Some(EulynxCommandedEndPosition::NOT_COMMANDED)) {
    (Some(l), Some(r)) => Some(l == r),
    _ => None
  }).unwrap_or(false) {
            self.CommandedEndPosition = EulynxCommandedEndPosition::NOT_COMMANDED;
        }
    }
}
