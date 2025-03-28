LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.MYWORK.all;

ENTITY ModSub IS
PORT(X1, X2: IN SIGNED (63 DOWNTO 0);
		XOUT: OUT SIGNED (63 DOWNTO 0));
END ModSub;

ARCHITECTURE arch OF ModSub IS
SIGNAL tmpX: SIGNED (63 DOWNTO 0);
BEGIN
	tmpX <= (X1 - X2);
	XOUT <= tmpX WHEN tmpX(63) = '0' ELSE tmpX + SIGNED(P);
END arch;

