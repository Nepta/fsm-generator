function removeFirst(string,n)
	if string ~= nil then
		n = n or 1
		return string:sub(-(string:len()-n))
	end
end

function removeLast(string,n)
	if string ~= nil then
		n = n or 1
		return string:sub(1,string:len()-n)
	end
end

function newState(table)
	local keyCount = {}
	keyCount.__len = function(table)
		local i = 0
		for k,v in pairs(table) do
			if type(k) == "string" then
				i = i+1
			end
		end
		return i
	end
	keyCount.__newindex = function(t, key, value)
		assert(k ~= "output", "can't have a input named 'output'")
		rawset(t,key,value)
	end
	
	keyCount.__index = {output = table.output}
	table.output = nil
	return setmetatable(table,keyCount)
end


function generateInputs(stateMachineInputs)
	local inputs = ""
	local inputs_signals = ""
	for k,v in pairs(stateMachineInputs) do
		inputs = inputs..";\n\t\t"..k..": in "..v
		inputs_signals = inputs_signals..", "..k
	end
	inputs = removeFirst(inputs,2)..";"
	inputs_signals = removeFirst(inputs_signals,2)
	return inputs, inputs_signals
end

function generateOutputs(stateMachineOutputs)
	local outputs = ""
	local default_outputs = ""
	for k,v in pairs(stateMachineOutputs) do
		outputs = outputs..";\n\t\t"..k..": out "..v
		local outputValue = "'0'"
		if stateMachine.outputs[k] ~= "std_logic" then
			outputValue = "(others => '0')"
		end
		default_outputs = default_outputs..";\n\t\t"..k.." <= "..outputValue
	end
	outputs = removeFirst(outputs,2)..";"
	default_outputs = removeFirst(default_outputs,2)..";"
	return outputs, default_outputs
end

function generateState(stateMachineState)
	local state = ""
	for k,v in pairs(stateMachineState) do
		state = state..", "..k
	end
	state = removeFirst(state,2)..";"
	return state
end

function generateEvolution(stateMachineState)
	local evolution = ""
	for k,v in pairs(stateMachineState) do
		evolution = evolution..";"..
			"\n\t\t\t\twhen "..k.." =>"
		if #v == 0 then
			evolution = evolution.." next_state <= "..v[1]
		else
			for input,nextState in pairs(v) do
				local inputValue = "'1'"
				if stateMachine.inputs[input] ~= "std_logic" then
					inputValue = "(others => '1')"
				end
				evolution = evolution..
					"\n\t\t\t\t\tif "..input.." = "..inputValue.." then "..
						"\n\t\t\t\t\t\tnext_state <= "..nextState..";"..
					"\n\t\t\t\t\tend if"
			end
		end
	end
	evolution = removeFirst(evolution,2)..";"
	return evolution
end

function generateActions(stateMachineState)
	local actions = ""
	for k,v in pairs(stateMachineState) do
		if v.output ~= nil then
			actions = actions..";\n\t\t\twhen "..k.." => "
			local outAssignement = ""
			for index,action in ipairs(v.output) do
				local inputValue = "'1'"
				if stateMachine.outputs[action] ~= "std_logic" then
					inputValue = "(others => '1')"
				end
				outAssignement = outAssignement.."; "..action.." <= "..inputValue
			end
			outAssignement = removeFirst(outAssignement,2)
			actions = actions .. outAssignement
		end
	end
	actions = removeFirst(actions,2)..";"
	return actions
end


