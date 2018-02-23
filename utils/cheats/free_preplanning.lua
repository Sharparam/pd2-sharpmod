local sm = SharpMod
local log = sm.log
local cm = sm.cheat_manager
local backuper = sm.backuper

return cm:add('free_preplanning', 'Free pre-planning', function(self)
    if MoneyManager then
        backuper:backup('MoneyManager.get_preplanning_type_cost')
        function MoneyManager.get_preplanning_type_cost() return 0 end

        backuper:backup('MoneyManager.can_afford_preplanning_type')
        function MoneyManager.can_afford_preplanning_type() return true end

        backuper:backup('MoneyManager.get_preplanning_votes_cost')
        function MoneyManager.get_preplanning_votes_cost() return 0 end

        self.moneymanager_replaced = true
        log:debug('MoneyManager replaced')
    end

    if PrePlanningManager then
        backuper:backup('PrePlanningManager.get_type_budget_cost')
        function PrePlanningManager.get_type_budget_cost() return 0 end

        backuper:backup('PrePlanningManager.can_reserve_mission_element')
        function PrePlanningManager.can_reserve_mission_element() return true end

        backuper:backup('PrePlanningManager.can_vote_on_plan')
        function PrePlanningManager.can_vote_on_plan() return true end

        self.preplanningmanager_replaced = true
        log:debug('PrePlanningManager replaced')
    end
end, function(self)
    if self.moneymanager_replaced then
        backuper:restore('MoneyManager.get_preplanning_type_cost')
        backuper:restore('MoneyManager.can_afford_preplanning_type')
        backuper:restore('MoneyManager.get_preplanning_votes_cost')
        self.moneymanager_replaced = false
    end

    if self.preplanningmanager_replaced then
        backuper:restore('PrePlanningManager.get_type_budget_cost')
        backuper:restore('PrePlanningManager.can_reserve_mission_element')
        backuper:restore('PrePlanningManager.can_vote_on_plan')
        self.preplanningmanager_replaced = false
    end
end)
