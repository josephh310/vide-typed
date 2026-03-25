local source = require "./source"
local derive = require "./derive"
local effect = require "./effect"
local switch = require "./switch"

local function show<T>(
    input: () -> unknown,
    component: () -> T,
    fallback: (() -> T)?
): () -> T?
    local filtered_input = source()

    effect(function()
        local v = input()
        if v then
            filtered_input(v)
        end
    end)

    local input_is_truthy = derive(function()
        return not not input()
    end)

    return (switch(input_is_truthy) :: any) {
        [true] = function(present: any)
            return (component :: any)(filtered_input, present)
        end,
        [false] = fallback :: any
    }
end

return show
