stateMachine = {
	inputs = {
		enable = "std_logic",
		enablev = "std_logic_vector(3 downto 0)",
	};
	outputs = {
		miaou = "std_logic_vector(3 downto 0)",
		miaoul = "std_logic",
	};
	init = "one";
	state = {
		one = newState{enablev = "two", enable = "three",output = {"miaou"}},
		two = newState{enable = "three",},
		three = newState{enable = "four",},
		four = newState{enable = "five",},
		five = newState{"six",},
		six = newState{enable = "seven", output = {"miaou", "miaoul"}},
		seven = newState{enable = "eight",},
		eight = newState{enable = "nine",},
		nine = newState{enable = "one",},
	};
}

