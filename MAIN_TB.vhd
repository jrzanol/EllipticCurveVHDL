LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;
USE ieee.std_logic_textio.ALL;

ENTITY MAIN_TB IS
END MAIN_TB;

ARCHITECTURE arch OF MAIN_TB IS

	-- Declaração do componente:
	COMPONENT MAIN IS
	PORT(CLK, RESET, START: IN STD_LOGIC;
			PublicKey: OUT STD_LOGIC_VECTOR (71 DOWNTO 0);
			DONE: OUT STD_LOGIC);
	END COMPONENT;

	-- Sinais intermediários para chamar o componente:
	SIGNAL CLK       : STD_LOGIC := '0';
	SIGNAL RESET     : STD_LOGIC := '1';
	SIGNAL START     : STD_LOGIC := '0';
	SIGNAL PublicKey : STD_LOGIC_VECTOR(71 DOWNTO 0);
	SIGNAL DONE      : STD_LOGIC;

	-- Clock:
	CONSTANT CLK_PERIOD : TIME := 10 ns;

	-- Função para converter para Hexadecimal:
	FUNCTION to_hex_char(slv : STD_LOGIC_VECTOR(3 DOWNTO 0)) RETURN CHARACTER IS
	BEGIN
		CASE slv IS
			WHEN "0000" => RETURN '0';
			WHEN "0001" => RETURN '1';
			WHEN "0010" => RETURN '2';
			WHEN "0011" => RETURN '3';
			WHEN "0100" => RETURN '4';
			WHEN "0101" => RETURN '5';
			WHEN "0110" => RETURN '6';
			WHEN "0111" => RETURN '7';
			WHEN "1000" => RETURN '8';
			WHEN "1001" => RETURN '9';
			WHEN "1010" => RETURN 'A';
			WHEN "1011" => RETURN 'B';
			WHEN "1100" => RETURN 'C';
			WHEN "1101" => RETURN 'D';
			WHEN "1110" => RETURN 'E';
			WHEN "1111" => RETURN 'F';
			WHEN OTHERS => RETURN 'X';
		END CASE;
	END FUNCTION;

BEGIN
	MAINCALL: MAIN PORT MAP(CLK, RESET, START, PublicKey, DONE);

    -- Geração de Clock:
    PROCESS
    BEGIN
        WHILE TRUE LOOP
            CLK <= '0';
            WAIT FOR CLK_PERIOD / 2;
            CLK <= '1';
            WAIT FOR CLK_PERIOD / 2;
        END LOOP;
    END PROCESS;

	PROCESS
		FILE output_file : TEXT OPEN WRITE_MODE IS "public_key_output.txt";
		VARIABLE line_buffer : LINE;
		VARIABLE hex_char : CHARACTER;
	BEGIN
		-- Reset do sistema:
		RESET <= '1';
		WAIT FOR CLK_PERIOD;
		RESET <= '0';
		WAIT FOR CLK_PERIOD;

		-- Inicia a listagem das Chaves Públicas:
		FOR pk IN 2 TO 32 LOOP
			START <= '1';
			WAIT FOR CLK_PERIOD;

			-- Aguarda o DONE para escrever no arquivo:
			WAIT UNTIL DONE = '1';
			WAIT FOR CLK_PERIOD*10;

			-- Escreve os dados no arquivo:
			WRITE(line_buffer, STRING'("PrivateKey: "));
			WRITE(line_buffer, pk);
			WRITE(line_buffer, STRING'(" PublicKey: "));

			FOR i IN 17 DOWNTO 0 LOOP
				hex_char := to_hex_char(PublicKey((i+1)*4-1 DOWNTO i*4));
				WRITE(line_buffer, hex_char);
			END LOOP;
			
			WRITELINE(output_file, line_buffer);
			
			START <= '0';
			WAIT FOR CLK_PERIOD*4;
		END LOOP;
		
		FILE_CLOSE(output_file);
		
		-- Finaliza o teste:
		WAIT FOR CLK_PERIOD*10;
		REPORT "Testbench finalizado!" SEVERITY NOTE;
		WAIT;
	END PROCESS;
END arch;

