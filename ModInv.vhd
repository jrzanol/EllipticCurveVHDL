LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ModInv IS
PORT(CLK, RESET, START: IN STD_LOGIC;
		A, B: IN UNSIGNED(63 downto 0);
		DONE: OUT STD_LOGIC;
		INVERSE: OUT UNSIGNED(63 downto 0));
END ModInv;

ARCHITECTURE arch OF ModInv IS
	-- Máquina de Estados:
	TYPE STATE_TYPE IS(WAITING, COMPUTE, COMPUTE2, COMPUTE3, DONE_STATE);
	SIGNAL STATE: STATE_TYPE;

	-- Variáveis temporárias dos coeficientes:
	SIGNAL r0, r1, r2, s0, s1, s2, t0, t1, t2, q : UNSIGNED(63 downto 0);

BEGIN
	PROCESS(CLK, RESET)
	BEGIN
		IF RESET = '1' THEN
			STATE <= WAITING;
			DONE <= '0';
			INVERSE <= (others => '0');
		ELSIF rising_edge(CLK) THEN
			CASE STATE IS
				WHEN WAITING =>
					IF START = '1' THEN
						r0 <= A;
						r1 <= B;
						s0 <= to_unsigned(1, 64);
						s1 <= to_unsigned(0, 64);
						t0 <= to_unsigned(0, 64);
						t1 <= to_unsigned(1, 64);
						STATE <= COMPUTE;
					END IF;

				WHEN COMPUTE =>
					IF r1 = to_unsigned(0, 64) THEN
						-- Inverso encontrado:
						INVERSE <= UNSIGNED(SIGNED(s0) MOD SIGNED(B));
						STATE <= DONE_STATE;
						DONE <= '1';
					ELSE
						-- Inicia o cálculo pelo quociente:
						q <= (r0 / r1);
						STATE <= COMPUTE2;
					END IF;

					WHEN COMPUTE2 =>
						-- Calculo dos coeficientes:
						r2 <= (r0 mod r1);
						s2 <= s0 - resize(q * s1, 64);
						t2 <= t0 - resize(q * t1, 64);
						STATE <= COMPUTE3;

					WHEN COMPUTE3 =>
						-- Atualiza as variáveis temporárias:
						r0 <= r1;
						r1 <= r2;
						s0 <= s1;
						s1 <= s2;
						t0 <= t1;
						t1 <= t2;
						STATE <= COMPUTE;

					WHEN DONE_STATE =>
						IF START = '0' THEN
							DONE <= '0';
							STATE <= WAITING;
						END IF;
			END CASE;
		END IF;
	END PROCESS;
END arch;

