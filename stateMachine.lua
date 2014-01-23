#!/usr/bin/lua
require "stateMachineFunc"
require "stateMachineDescription"

inputs, inputs_signals = generateInputs(stateMachine.inputs)
outputs, default_outputs = generateOutputs(stateMachine.outputs)
state = generateState(stateMachine.state)
evolution = generateEvolution(stateMachine.state)
actions = generateActions(stateMachine.state)

templateFile = io.open("machine_etat_template.vhd")
template = templateFile:read("*a")
templateFile:close()
templateFile = nil

vhdlFile = io.open("state_machine.vhd","w")

template = template:gsub("#entity#","stateMachine")
template = template:gsub("#architecture#","RTL")
template = template:gsub("#states#",state)
template = template:gsub("#initial_state#",stateMachine["init"])
template = template:gsub("#inputs#",inputs)
template = template:gsub("#inputs_signals#",inputs_signals)
template = template:gsub("#outputs#",outputs)
template = template:gsub("#default_outputs#",default_outputs)
template = template:gsub("#evol_states#",evolution)
template = template:gsub("#actions#",actions)

vhdlFile:write(template)

vhdlFile:close()

