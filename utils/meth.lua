local log = SharpMod.log 'meth'

local ingredient_hints = {
    --pln_rt1_12 = 'Ingredient added',
    pln_rt1_20 = 'Add Muriatic Acid',
    pln_rt1_22 = 'Add Caustic Soda',
    pln_rt1_24 = 'Add Hydrogen Chloride',
    --pln_rt1_28 = 'Meth batch is complete',
    pln_rat_stage1_20 = 'Add Muriatic Acid',
    pln_rat_stage1_22 = 'Add Caustic Soda',
    pln_rat_stage1_24 = 'Add Hydrogen Chloride',
    --pln_rat_stage1_28 = 'Meth batch is complete'
}

local _queue_dialog_orig = DialogManager.queue_dialog
function DialogManager:queue_dialog(id, ...)
    log:verbose('Dialog ID: %s', id)

    if ingredient_hints[id] then
        local text = ingredient_hints[id]
        log:info(text):system(text):hint(text):objective('Objective updated', text)
    end

    return _queue_dialog_orig(self, id, ...)
end
