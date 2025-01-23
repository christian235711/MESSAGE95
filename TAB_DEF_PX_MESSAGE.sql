 **
*-- Description : Creation de la
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


DROP TABLE SCHEMA3.TAB_DEF_PX_MESSAGE    CASCADE CONSTRAINTS;


CREATE TABLE SCHEMA3.TAB_DEF_PX_MESSAGE (
DATE_CLE		VARCHAR2(6),
CODE_AB 	 	VARCHAR2(6),
CODE_F1			VARCHAR2(13),
CODE_F2			VARCHAR2(16),
ELABORATION_DATE	DATE,
CODE_CT			VARCHAR2(9),
CODE_FN			VARCHAR2(3),
CHAMPS_TP		VARCHAR2(1),
EVENT_PERIOD_T	        VARCHAR2(1),
EVENT_PERIOD_T_1	VARCHAR2(1),
EVENT_PERIOD_T_2	VARCHAR2(1),
FLAG_ENVOI_DELTA	VARCHAR2(1),
DATE_ENVOI		DATE
);

-- -------------------------------------------------------------------------
-- INDEX
-- -------------------------------------------------------------------------
----------------------------------------------------------------------------
CREATE UNIQUE INDEX  SCHEMA3.INDEX_MESSAGE95 ON SCHEMA3.TAB_DEF_PX_MESSAGE
		(DATE_CLE, CODE_AB, CODE_F1, CODE_F2)  
LOGGING
TABLESPACE &&V_TBS_I;


----------------------------------------------------------------------------
-- CONSTRAINT PK
----------------------------------------------------------------------------
ALTER TABLE SCHEMA3.TAB_DEF_PX_MESSAGE ADD (
  CONSTRAINT INDEX_MESSAGE95 PRIMARY KEY 
(DATE_CLE, CODE_AB, CODE_F1, CODE_F2)   USING INDEX   
TABLESPACE &&V_TBS_I);



----------------------------------------------------------------------------
-- GRANT
----------------------------------------------------------------------------
GRANT SELECT ON SCHEMA3.TAB_DEF_PX_MESSAGE TO SCHEMA1;

----------------------------------------------------------------------------
-- COMMENTS
----------------------------------------------------------------------------


SHOW ERRORS
SPOOL OFF
exit;
