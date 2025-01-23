 **
*-- Description : Creation de 
-- Auteur : moi
*-- Date Creation :
*/
-- -------------------------------------------------------------------------
-- Chargement des paramÃ¨tres ORACLE
-- -------------------------------------------------------------------------

SET SERVEROUTPUT ON
SET TERMOUT ON
SET ECHO ON
SET FEED ON
SET HEAD ON

@@table_param.sql

-- -------------------------------------------------------------------------
-- LOG
-- -------------------------------------------------------------------------

-- -------------------------------------------------------------------------
-- TABLE
-- -------------------------------------------------------------------------


DROP TABLE SCHEMA3.TAB_DEF_PXCR95    CASCADE CONSTRAINTS;


CREATE TABLE SCHEMA3.TAB_DEF_PXCR95 (
DATE_CLE	VARCHAR2(6),
CODE_AB		VARCHAR2(6),
CODE_F1		VARCHAR2(13),
CODE_F2		VARCHAR2(16),
CODE_TX		VARCHAR2(34),
CODE_CT		VARCHAR2(9),
CODE_FN		VARCHAR2(3),
ID_CLE		VARCHAR2(15),
FINAN_VAL	NUMBER(18,3),
VAL_UST		NUMBER(18,3)
);

-- -------------------------------------------------------------------------
-- INDEX
-- -------------------------------------------------------------------------
----------------------------------------------------------------------------
CREATE UNIQUE INDEX  SCHEMA3.INDEX_CR ON SCHEMA3.TAB_DEF_PXCR95
		(DATE_CLE, ID_CLE)  
LOGGING
TABLESPACE &&V_TBS_I;


----------------------------------------------------------------------------
-- CONSTRAINT PK
----------------------------------------------------------------------------
ALTER TABLE SCHEMA3.TAB_DEF_PXCR95 ADD (
  CONSTRAINT INDEX_CR PRIMARY KEY 
(DATE_CLE, ID_CLE)    USING INDEX   
TABLESPACE &&V_TBS_I);



----------------------------------------------------------------------------
-- GRANT
----------------------------------------------------------------------------
GRANT SELECT ON SCHEMA3.TAB_DEF_PXCR95 TO FDS;


----------------------------------------------------------------------------
-- COMMENTS
----------------------------------------------------------------------------


SHOW ERRORS
SPOOL OFF
exit;
