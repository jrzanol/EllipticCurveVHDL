LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.MYWORK.all;

ENTITY MAIN IS
PORT(CLK, RESET, START: IN STD_LOGIC;
		PublicKey: OUT STD_LOGIC_VECTOR (71 DOWNTO 0);
		DONE: OUT STD_LOGIC);
END MAIN;

ARCHITECTURE arch OF MAIN IS
SIGNAL CurrentX, CurrentY : SIGNED (63 DOWNTO 0);
SIGNAL OutX, OutY : SIGNED (63 DOWNTO 0) := (OTHERS => '0');
SIGNAL AddPointDone : STD_LOGIC := '0';

BEGIN
	PROCESS (CLK, RESET)
	BEGIN
		IF RESET = '1' THEN
			CurrentX <= SIGNED(Gx2);
			CurrentY <= SIGNED(Gy2);
		ELSIF rising_edge(CLK) THEN
			IF AddPointDone = '1' THEN
				CurrentX <= OutX;
				CurrentY <= OutY;
			END IF;
		END IF;
	END PROCESS;

CALCPK: AddOnePoint PORT MAP(CLK, RESET, START, CurrentX, CurrentY, OutX, OutY, AddPointDone);

	PublicKey <= ("00000010" OR ("0000000" & CurrentY(0))) & STD_LOGIC_VECTOR(CurrentX);
	DONE <= AddPointDone;
END arch;

