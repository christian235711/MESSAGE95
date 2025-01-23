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


DROP TABLE SCHEMA1.TAB_DEF_CR95    CASCADE CONSTRAINTS;


CREATE TABLE SCHEMA1.TAB_DEF_CR95 (
REF_PERIOD		VARCHAR2(6),
DATE_CLE		DATE,
ID_CLE			VARCHAR2(15),
SOLDE			NUMBER(18,3),
FLAG			VARCHAR2(1)
);
	
-- -------------------------------------------------------------------------
-- INDEX
-- -------------------------------------------------------------------------
----------------------------------------------------------------------------
CREATE UNIQUE INDEX  SCHEMA1.INDEX_EVENT1 ON SCHEMA1.TAB_DEF_CR95
		(DATE_EVENT, IE_AFFAIRE)  
LOGGING
TABLESPACE &&V_TBS_I;


----------------------------------------------------------------------------
-- CONSTRAINT PK
----------------------------------------------------------------------------
ALTER TABLE SCHEMA1.TAB_DEF_CR95 ADD (
  CONSTRAINT INDEX_EVENT1 PRIMARY KEY 
(DATE_EVENT, IE_AFFAIRE)  USING INDEX   
TABLESPACE &&V_TBS_I);



----------------------------------------------------------------------------
-- GRANT
----------------------------------------------------------------------------
GRANT SELECT, UPDATE ON SCHEMA1.TAB_DEF_CR95 TO SCHEMA3;

----------------------------------------------------------------------------
-- COMMENTS
----------------------------------------------------------------------------


SHOW ERRORS
SPOOL OFF
exit;
