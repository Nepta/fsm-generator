library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity #entity# is
	port(
		clk, resetn: in std_logic;
#inputs#
#outputs#
	);
end entity;

architecture #architecture# of #entity# is
	type state is (#states#);
	signal current_state, next_state : state;
begin
	evolution : process(current_state,#inputs_signals#) is
		begin
			next_state <= current_state;
			case current_state is
#evol_states#
			end case;
	end process;
	
	actions: process(current_state) is
	begin
#default_outputs#
		case current_state is
#actions#
			when others => null;
		end case;
	end process;

	synchronisation: process(clk, resetn) is
	begin
		if resetn = '0' then
			current_state <= #initial_state#;
		elsif rising_edge(clk) then
			current_state <= next_state;
		end if;
	end process;
end architecture;
