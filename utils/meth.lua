local sm = _G.SharpMod
local log = sm.log 'meth'

local dialog_data = {
    pln_rt1_12 = {
        text = 'Ingredient added',
        type = 'status'
    },
    pln_rt1_20 = {
        text = 'Add Muriatic Acid',
        type = 'ingredient'
    },
    pln_rt1_22 = {
        text = 'Add Caustic Soda',
        type = 'ingredient'
    },
    pln_rt1_23 = {
        text = 'Meth cooking failed',
        type = 'status'
    },
    pln_rt1_24 = {
        text = 'Add Hydrogen Chloride',
        type = 'ingredient'
    },
    pln_rt1_28 = {
        text = 'Meth batch is complete',
        type = 'status'
    },
    pln_rat_stage1_20 = {
        text = 'Add Muriatic Acid',
        type = 'ingredient'
    },
    pln_rat_stage1_22 = {
        text = 'Add Caustic Soda',
        type = 'ingredient'
    },
    pln_rat_stage1_24 = {
        text = 'Add Hydrogen Chloride',
        type = 'ingredient'
    },
    pln_rat_stage1_28 = {
        text = 'Meth batch is complete',
        type = 'status'
    },
    Play_pln_nai_16 = {
        text = 'Meth cooking failed',
        type = 'status'
    },
    Play_loc_mex_cook_03 = {
        text = 'Add Muriatic Acid',
        type = 'ingredient'
    },
    Play_loc_mex_cook_04 = {
        text = 'Add Caustic Soda',
        type = 'ingredient'
    },
    Play_loc_mex_cook_05 = {
        text = 'Add Hydrogen Chloride',
        type = 'ingredient'
    },
    Play_loc_mex_cook_12 = {
        text = 'Meth cooking failed',
        type = 'status'
    },
    Play_loc_mex_cook_14 = {
        text = 'Meth batch is complete',
        type = 'status'
    },
    Play_loc_mex_cook_17 = {
        text = 'Meth batch is complete',
        type = 'status'
    },
    Play_loc_mex_cook_22 = {
        text = 'Ingredient added',
        type = 'status'
    }
}

local function process_dialog(id)
    log:verbose('Dialog ID: %s', id)

    local options = _G.SharpMod.options.meth

    if not options.enabled then return end

    local data = dialog_data[id]
    if not data then return end
    local text = data.text
    local type = data.type

    if type == 'ingredient' and not options.ingredients then return end
    if type == 'status' and not options.status then return end

    log:info(text):system(text):hint(text):objective('Objective updated', text)

    if options.chat then
        log:chat(text)
    end
end

local _queue_dialog_orig = DialogManager.queue_dialog
function DialogManager:queue_dialog(id, ...)
    process_dialog(id)
    return _queue_dialog_orig(self, id, ...)
end
