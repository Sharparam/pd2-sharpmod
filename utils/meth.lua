local log = _G.SharpMod.log 'meth'

local ingredient_hints = {
    --pln_rt1_12 = 'Ingredient added',
    pln_rt1_20 = 'Add Muriatic Acid',
    pln_rt1_22 = 'Add Caustic Soda',
    pln_rt1_24 = 'Add Hydrogen Chloride',
    --pln_rt1_28 = 'Meth batch is complete',
    pln_rat_stage1_20 = 'Add Muriatic Acid',
    pln_rat_stage1_22 = 'Add Caustic Soda',
    pln_rat_stage1_24 = 'Add Hydrogen Chloride',
    --pln_rat_stage1_28 = 'Meth batch is complete',
    Play_loc_mex_cook_03 = 'Add Muriatic Acid',
    Play_loc_mex_cook_04 = 'Add Caustic Soda',
    Play_loc_mex_cook_05 = 'Add Hydrogen Chloride'
}

local _queue_dialog_orig = DialogManager.queue_dialog
function DialogManager:queue_dialog(id, ...)
    log:verbose('Dialog ID: %s', id)

    local text = ingredient_hints[id]
    if text then
        log:info(text):system(text):hint(text):objective('Objective updated', text)
    end

    return _queue_dialog_orig(self, id, ...)
end
