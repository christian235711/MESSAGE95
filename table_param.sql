-- ###############################################################
-- Fichier de parametrage a adapter en fonction
-- de l'environnement (dev, recette, pre-prod, prod)
-- ###############################################################
-- Modif le  : daterr
/*= Appli ======================================================*/
-- DEFINE V_SCHEMA_RACINE = 'SCHEMA1'
DEFINE V_APPLI_CTRL = 'SCHEMA6'
DEFINE V_APPLI_LDR = 'SCHEMA2'
DEFINE V_APPLI_RSK = 'SCHEMA7'
DEFINE V_APPLI_CM = 'SCHEMA8'
DEFINE V_APPLI_BIL = 'SCHEMA3'
DEFINE V_APPLI = 'SCHEMA1'
-- DEFINE V_APPLIC = '' 

/*= TableSpaces ================================================*/
DEFINE V_TBS_D = 'SPACE_T1' 
DEFINE V_TBS_I = 'SPACE_T2'
DEFINE V_TBS_T = 'SPACE_T3' 

/*= Parametres ================================================*/
/*= Volume de donnees : Petit =================================*/
DEFINE V_INIT1 = 120
DEFINE V_NEXT1 = 120
DEFINE V_MIN1 = 1
DEFINE V_MAX1 = 1024
DEFINE V_INCR1 = 0

/*= Volume de donnees : Moyen =================================*/
DEFINE V_INIT2 = 120 --128K
DEFINE V_NEXT2 = 120 --128K
DEFINE V_MIN2 = 1
DEFINE V_MAX2 = 1024
DEFINE V_INCR2 = 0

/*= Volume de donnees : Grand =================================*/
DEFINE V_INIT3 = 128 --120 --128K
DEFINE V_NEXT3 = 128 --120 --128K
DEFINE V_MIN3 = 1
DEFINE V_MAX3 = 2048 --1024 --2048
DEFINE V_INCR3 = 0

